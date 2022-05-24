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
/* VARABLES DETECTOR DTMF asdsad */
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
bqStatus_t tuneBsfState = { // Inicialmente para 500Hz y 100Hz de bw
    -1.942499503811206,               // A1
    0.980555318909952,                // A2
    0.990277659454976,                // B0
    -1.942499503811206,               // B1
    0.990277659454976,                // B2
    {0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0}
};


bqStatus_t BPF0 = { // 697 Hz
    -1.895767606089256,               // A1
    0.969067417193795,                // A2
    0.01546629140310257,              // B0
    0,               // B1
    -0.01546629140310257,                // B2
    {0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0}
};

bqStatus_t BPF1 = { // 770 Hz
    -1.879732707662667,               // A1
    0.969067417193795,                // A2
    0.01546629140310257,                // B0
    0,               // B1
    -0.01546629140310257,                // B2
    {0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0}
};

bqStatus_t BPF2 = { // 852 Hz
    -1.859879547221657,               // A1
    0.969067417193795,                // A2
    0.01546629140310257,                // B0
    0,               // B1
    -0.01546629140310257,                // B2
    {0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0}
};

bqStatus_t BPF3 = { // 941 Hz
    -1.836149973561146,               // A1
    0.969067417193795,                // A2
    0.01546629140310257,                // B0
    0,               // B1
    -0.01546629140310257,                // B2
    {0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0}
};

bqStatus_t BPF4 = { // 1209 Hz
    -1.744534596215547,               // A1
    0.961481451595328,                // A2
    0.01925927420233614,                // B0
    0,               // B1
    -0.01925927420233614,                // B2
    {0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0}
};

bqStatus_t BPF5 = { // 1336 Hz
    -1.697664805622379,               // A1
    0.961481451595328,                // A2
    0.01925927420233614,                // B0
    0,               // B1
    -0.01925927420233614,                // B2
    {0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0}
};

bqStatus_t BPF6 = { // 1447 Hz
    -1.640688189104886,               // A1
    0.961481451595328,                // A2
    0.01925927420233614,                // B0
    0,               // B1
    -0.01925927420233614,                // B2
    {0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0}
};

float tuneBsfOutput = 0.0;
float notchFreq     = 20.0;


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
        tuneBsfOutput = 0.0;

        /*-------------------------------------------------------------------*/
        /* FILTROS PARA DTMF */
        /*-------------------------------------------------------------------*/
        dtmfTones[0] = filterBiquad(&BPF0, floatCodecInputR));
        dtmfTones[1] = filterBiquad(&BPF1, floatCodecInputR));
        dtmfTones[2] = filterBiquad(&BPF2, floatCodecInputR));
        dtmfTones[3] = filterBiquad(&BPF3, floatCodecInputR));
        dtmfTones[4] = filterBiquad(&BPF4, floatCodecInputR));
        dtmfTones[5] = filterBiquad(&BPF5, floatCodecInputR));
        dtmfTones[6] = filterBiquad(&BPF6, floatCodecInputR));

        dtmfDetection(dtmfTones);

        /*-------------------------------------------------------------------*/
        /* PARA VISUALIZAR EN GRÁFICO */
        /*-------------------------------------------------------------------*/
        DLU_enableSynchronicSingleCaptureOnAllGraphBuff();
        DLU_appendGraphBuff1(floatCodecInputR);
        DLU_appendGraphBuff2(filterBiquad(&tuneBsfState, floatCodecInputR));

        /*-------------------------------------------------------------------*/
        /* ESCRITURA EN SALIDA DEL CODEC */
        /*-------------------------------------------------------------------*/
        floatCodecOutputL = floatCodecInputR;
        floatCodecOutputR = filterBiquad( &tuneBsfState, floatCodecInputR);

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
    DLU_configTrimmerCounter(0, 1000);
    DLU_configTrimmerAutoIncrement(1000, 5);

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
    if ( DLU_readPushButton1() ) {
        tuneFreq = tuneFreq - 20;
    }
    if ( DLU_readPushButton2() ) {
        tuneFreq = tuneFreq + 20;
    }
    float d = 0.980555318909952;
    float theta = 2*3.141592653589793*tuneFreq/16000;       // frec s = 16kHz
    //*tuneBsfState->bqA1 = (1+d)*cos(theta);
    //*tuneBsfState->bqB1 = -(1+d)*cos(theta);
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
