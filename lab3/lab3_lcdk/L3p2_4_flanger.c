/******************************************************************************
* \file     Lab3p2.c
*
* \brief    Experiencia 3 de laboratorio DSP ELO314
*
* \authors  Gonzalo Carrasco
******************************************************************************/

/******************************************************************************
**      HEADER FILES
******************************************************************************/
#include "dlu_global_defs.h"
#include "L138_LCDK_aic3106_init.h"
#include "dsp_lab_utils.h"
#include <math.h>
#include "dlu_codec_config.h"

/******************************************************************************
**      MODULE PREPROCESSOR CONSTANTS
******************************************************************************/

/******************************************************************************
**      MODULE MACROS
******************************************************************************/
#define DTMF_ENV_FRAME_SIZE     (32)  // 1ms
#define DTMF_DET_LEVEL          (0.002)
#define DTMF_CH_SNR_RATE        (2.5)

#define AUDIOBUFFERSIZE         (1000)

#define F_SWEEP                 (0.6)   // idealmente entre 0 y 1
#define F_GAIN                  (1)     // ídem
#define F_FREQ                  (0.9)   // frecuencia de flanger en Hz
#define F_AVGDELAY              (100)   // retraso promedio en muestras

/******************************************************************************
**      MODULE DATATYPES
******************************************************************************/
/*
 * Estructura de estado de filtros biquad
 */
typedef struct bqStatus_t {
    float bqA1;
    float bqA2;
    float bqB0;
    float bqB1;
    float bqB2;
    float bqInput[3];
    float bqOutput[3];
} bqStatus_t;

/******************************************************************************
**      MODULE VARIABLE DEFINITIONS
******************************************************************************/

/*---------------------------------------------------------------------------*/
/* ENTRADAS Y SALIDAS DEL AIC CODEC */
/*---------------------------------------------------------------------------*/
/*
 * Tipo de dato para el CODEC (Union)
 */
AIC31_data_type codec_data;

/*
 * Varibles de entrada y salida en formato flotante
 */
float floatCodecInputR,floatCodecInputL;
float floatCodecOutputR,floatCodecOutputL;

/*
 * Variables de estado de salida saturada
 */
int outSaturationStat = 0;

//#pragma DATA_SECTION(audioBufferR,".EXT_RAM")
//#pragma DATA_SECTION(audioBufferL,".EXT_RAM")

/*---------------------------------------------------------------------------*/
/* VARABLES DETECTOR DTMF */
/*---------------------------------------------------------------------------*/
/* Señales de salida para cada filtro */
float dtmfTones[7];

int32_t framePos = 0;
float tonesAmplitud[7]={0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
float tonesAmpAux[7]={0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
int32_t dtmfSymbol = 0;

/*---------------------------------------------------------------------------*/
/* VARABLES FILTRO NOTCH */
/*---------------------------------------------------------------------------*/

float tuneBsfOutput = 0.0;
float notchFreq     = 20.0;

int16_t gM = 0.0;
float gSweep = F_SWEEP;
float gGain = F_GAIN;
float gFreq = F_FREQ;
float gTheta = 0.0;
int16_t M0 = F_AVGDELAY;
float tuneFlanger = 0.0;

float       audioBufferL[AUDIOBUFFERSIZE];
uint32_t    idxAudioBufferRHead = 0, idxAudioBufferRRead = 0;

/******************************************************************************
**      PRIVATE FUNCTION DECLARATIONS (PROTOTYPES)
******************************************************************************/
float filterBiquad(bqStatus_t *filterNState, float filterInput);
void notchUpdate(float tuneFreq);
void envelopeDetector(float *tonesInputs);
void dtmfDetection(float *tonesInputs);

/******************************************************************************
**      FUNCTION DEFINITIONS
******************************************************************************/

interrupt void interrupt4(void) // interrupt service routine
{
//#############################################################################
        /*-------------------------------------------------------------------*/
        /* LECTURA DE ENTRADAS DEL CODEC */
        /*-------------------------------------------------------------------*/
        DLU_readCodecInputs(&floatCodecInputL, &floatCodecInputR);

        /*-------------------------------------------------------------------*/
        /* Inicia medición de tiempo de ejecución */
        DLU_tic();
        /*-------------------------------------------------------------------*/
        /* FILTRO NOTCH SINTONIZABLE */
        /*-------------------------------------------------------------------*/

        /*-------------------------------------------------------------------*/
        /* FILTROS PARA DTMF */
        /*-------------------------------------------------------------------*/
//        dtmfDetection(dtmfTones);

        /*-------------------------------------------------------------------*/
        /* FLANGER */
        /*-------------------------------------------------------------------*/

        // cálculo de retardo variable
        gTheta  = gTheta + 2.0 * M_PI* (gFreq) * TS;
            // Theta entre [0, 2*pi]
        if ( gTheta > 2.0 * M_PI )
        {
            gTheta = gTheta - 2.0*M_PI;
        }

            // retardo variable:
        gM = (int16_t)( M0 * (1 + gSweep * cos(gTheta)) );

        // buffer circular (experiencia 2)
        idxAudioBufferRRead = (idxAudioBufferRHead + AUDIOBUFFERSIZE - gM ) % AUDIOBUFFERSIZE;
        float valor_final_c = audioBufferL[idxAudioBufferRRead];

            // Actualizacion del buffer
        audioBufferL[idxAudioBufferRHead] = floatCodecInputR;
            // Actualizacion de la cabeza del buffer
        idxAudioBufferRHead = (idxAudioBufferRHead + 1) % AUDIOBUFFERSIZE;

        tuneFlanger = floatCodecInputR + gGain * valor_final_c;

        /*-------------------------------------------------------------------*/
        /* PARA VISUALIZAR EN GRÁFICO */
        /*-------------------------------------------------------------------*/
        DLU_enableSynchronicSingleCaptureOnAllGraphBuff();
        DLU_appendGraphBuff1(floatCodecInputR);
        DLU_appendGraphBuff2(tuneBsfOutput);

        /*-------------------------------------------------------------------*/
        /* ESCRITURA EN SALIDA DEL CODEC */
        /*-------------------------------------------------------------------*/
        floatCodecOutputL = tuneFlanger;
        floatCodecOutputR = tuneFlanger;

        /* Medición de tiempo de ejecución */
        DLU_toc();

        outSaturationStat = DLU_writeCodecOutputs(floatCodecOutputL,floatCodecOutputR);

//#############################################################################
    return;
}

void main()
{
    /* Inicialización de Pulsadores User 1 y User 2 */
    DLU_initPushButtons();
    /* Inicializa función de medición de tiempos de ejecución */
    DLU_initTicToc();
    /* Inicializacion BSL y AIC31 Codec */
    L138_initialise_intr(CODEC_FS, CODEC_ADC_GAIN, CODEC_DAC_ATTEN, CODEC_INPUT_CFG);
    /* Inicialización de LEDs */
    DLU_initLeds();
    /* Configuración de Trimmer ajustado con Pushbuttons */
    DLU_configTrimmerCounter(440, 880);
    DLU_configTrimmerAutoIncrement(200, 3);

   /* Loop infinito a espera de interrupción del Codec */
    while(1);
}

/******************************************************************************
*   \brief  Esta función implementa una etapa de filtro biquad
*
*   \param filterNState     : puntero a la estructura del biquad a ejecutar
*   \param filterInput      : señal de entrada al filtro biquad a ejecutar
*
*   \return filterOutput    : señal de salida del filtro biquad ejecutado
******************************************************************************/
float filterBiquad(bqStatus_t *filterNState, float filterInput){
    filterNState->bqInput[2] = filterNState->bqInput[1];
    filterNState->bqInput[1] = filterNState->bqInput[0];
    filterNState->bqInput[0] = filterInput;

    filterNState->bqOutput[2] = filterNState->bqOutput[1];
    filterNState->bqOutput[1] = filterNState->bqOutput[0];

    filterNState->bqOutput[0] = filterNState->bqB0 * filterNState->bqInput[0]
                                + filterNState->bqB1 * filterNState->bqInput[1]
                                + filterNState->bqB2 * filterNState->bqInput[2]
                                - filterNState->bqA1 * filterNState->bqOutput[1]
                                - filterNState->bqA2 * filterNState->bqOutput[2];

    /* Se retorna la salida */
    float filterOutput = filterNState->bqOutput[0];
    return filterOutput;
}

/******************************************************************************
*   \brief Esta función modifica los parámetros del filtro notch para ajustar
*           su frecuencia de sintonía. El ancho de banda en cambio se mantiene
*           constante y dependiente de la constante TUNE_BSF_D.
*
*   \param tuneFreq :  es la frecuencia de sintonía deseada en Hz.
*
*   \return Void.
******************************************************************************/
void notchUpdate(float tuneFreq){
    // completar
}

/******************************************************************************
*   \brief Esta función permite detectar de forma sencilla la envolvente
*           de los tonos filtrados.
*           Una vez se retorna de la función quedan actualizados los valores
*           de la variable 'tonesAmplitud'.

*   \param *tonesInputs : puntero a arreglo de canales filtrados
*
*   \return Void
******************************************************************************/
void envelopeDetector(float *tonesInputs) {
    int32_t idxTones;

    if( fabs( tonesInputs[0] ) > tonesAmpAux[0])
        tonesAmpAux[0] = fabs( tonesInputs[0] );
    if( fabs( tonesInputs[1] ) > tonesAmpAux[1])
        tonesAmpAux[1] = fabs( tonesInputs[1] );
    if( fabs( tonesInputs[2] ) > tonesAmpAux[2])
        tonesAmpAux[2] = fabs( tonesInputs[2] );
    if( fabs( tonesInputs[3] ) > tonesAmpAux[3])
        tonesAmpAux[3] = fabs( tonesInputs[3] );
    if( fabs( tonesInputs[4] ) > tonesAmpAux[4])
        tonesAmpAux[4] = fabs( tonesInputs[4] );
    if( fabs( tonesInputs[5] ) > tonesAmpAux[5])
        tonesAmpAux[5] = fabs( tonesInputs[5] );
    if( fabs( tonesInputs[6] ) > tonesAmpAux[6])
        tonesAmpAux[6] = fabs( tonesInputs[6] );

    framePos++;
    if ( framePos > DTMF_ENV_FRAME_SIZE )
    {
        framePos = 0;

        for (idxTones = 0; idxTones < 7; idxTones++)
        {
            tonesAmplitud[idxTones] = 0.5 * (tonesAmpAux[idxTones] + tonesAmplitud[idxTones]);
            tonesAmpAux[idxTones] = 0.0;
        }

    }

}

/******************************************************************************
*   \brief Función que actualiza el estado de los leds para indicar símbolo
*           detectado en base a reconocer DTFM.
*           Al retornar de esta función, los led se actualizan con el último
*           símbolo detectado.

*   \param *tonesInputs : puntero a arreglo de canales filtrados
*
*   \return Void
******************************************************************************/
void dtmfDetection(float *tonesInputs) {
    float levelAux;
    int32_t dtmf_row = 0;
    int32_t dtmf_col = 0;
    /*-----------------------------------------------------------------------*/
    /* Actualización de amplitudes */
    envelopeDetector(tonesInputs);

    /* Promedio de canales */
    levelAux = 0.143 * (tonesAmplitud[0] +
            tonesAmplitud[1] +
            tonesAmplitud[2] +
            tonesAmplitud[3] +
            tonesAmplitud[4] +
            tonesAmplitud[5] +
            tonesAmplitud[6] );
    /*-----------------------------------------------------------------------*/
    /* Detección de canal bajo */
    do
    {
        /* ¿Será fila 1? */
        levelAux = tonesAmplitud[0] / (tonesAmplitud[1] + tonesAmplitud[2] +tonesAmplitud[3]);
        if (levelAux > DTMF_CH_SNR_RATE)
        {
            dtmf_row = 1;
            break;
        }
        /* ¿Será fila 2? */
        levelAux = tonesAmplitud[1] / (tonesAmplitud[0] + tonesAmplitud[2] +tonesAmplitud[3]);
        if (levelAux > DTMF_CH_SNR_RATE)
        {
            dtmf_row = 2;
            break;
        }
        /* ¿Será fila 3? */
        levelAux = tonesAmplitud[2] / (tonesAmplitud[1] + tonesAmplitud[0] +tonesAmplitud[3]);
        if (levelAux > DTMF_CH_SNR_RATE)
        {
            dtmf_row = 3;
            break;
        }
        /* ¿Será fila 4? */
        levelAux = tonesAmplitud[3] / (tonesAmplitud[1] + tonesAmplitud[2] +tonesAmplitud[0]);
        if (levelAux > DTMF_CH_SNR_RATE)
        {
            dtmf_row = 4;
            break;
        }

    } while(0);

    /*-----------------------------------------------------------------------*/
    /* Detección de canal alto */
    do
    {
        /* ¿Será columna 1? */
        levelAux = tonesAmplitud[4] / (tonesAmplitud[5] + tonesAmplitud[6]);
        if (levelAux > DTMF_CH_SNR_RATE)
        {
            dtmf_col = 1;
            break;
        }
        /* ¿Será columna 2? */
        levelAux = tonesAmplitud[5] / (tonesAmplitud[4] + tonesAmplitud[6]);
        if (levelAux > DTMF_CH_SNR_RATE)
        {
            dtmf_col = 2;
            break;
        }
        /* ¿Será columna 3? */
        levelAux = tonesAmplitud[6] / (tonesAmplitud[4] + tonesAmplitud[5]);
        if (levelAux > DTMF_CH_SNR_RATE)
        {
            dtmf_col = 3;
            break;
        }

    } while(0);

    /*-----------------------------------------------------------------------*/
    /* Decodificación de número de símbolo */
    if ( ( dtmf_row >= 1 ) && (dtmf_col >= 1) )
        dtmfSymbol = dtmf_col + 3*(dtmf_row - 1);
    else
        dtmfSymbol = 0;

    /*-----------------------------------------------------------------------*/
    /* Actualización de LEDs */
    if ( dtmfSymbol == 1) // Símbolo: 1
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_OFF);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_ON);
    }
    else if ( dtmfSymbol == 2) // Símbolo: 2
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_OFF);
                    DLU_writeLedD6(LED_ON);
                    DLU_writeLedD7(LED_OFF);
    }
    else if ( dtmfSymbol == 3) // Símbolo: 3
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_OFF);
                    DLU_writeLedD6(LED_ON);
                    DLU_writeLedD7(LED_ON);
    }
    else if ( dtmfSymbol == 4) // Símbolo: 4
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_ON);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_OFF);
    }
    else if ( dtmfSymbol == 5) // Símbolo: 5
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_ON);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_ON);
    }
    else if ( dtmfSymbol == 6) // Símbolo: 6
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_ON);
                    DLU_writeLedD6(LED_ON);
                    DLU_writeLedD7(LED_OFF);
    }
    else if ( dtmfSymbol == 7) // Símbolo: 7
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_ON);
                    DLU_writeLedD6(LED_ON);
                    DLU_writeLedD7(LED_ON);
    }
    else if ( dtmfSymbol == 8) // Símbolo: 8
    {
                    DLU_writeLedD4(LED_ON);
                    DLU_writeLedD5(LED_OFF);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_OFF);
    }
    else if ( dtmfSymbol == 9) // Símbolo: 9
    {
                    DLU_writeLedD4(LED_ON);
                    DLU_writeLedD5(LED_OFF);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_ON);
    }
    else if ( dtmfSymbol == 10) // Símbolo: *
    {
                    DLU_writeLedD4(LED_ON);
                    DLU_writeLedD5(LED_ON);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_OFF);
    }
    else if ( dtmfSymbol == 11) // Símbolo: 0
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_OFF);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_OFF);
    }
    else if ( dtmfSymbol == 12) // Símbolo: #
    {
                    DLU_writeLedD4(LED_ON);
                    DLU_writeLedD5(LED_ON);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_ON);
    }
    else
    {
                    DLU_writeLedD4(LED_ON);
                    DLU_writeLedD5(LED_ON);
                    DLU_writeLedD6(LED_ON);
                    DLU_writeLedD7(LED_ON);
    }
}

/******************************************************************************
**      END OF SOURCE FILE
******************************************************************************/
