/******************************************************************************
* \file     Lab1p2_solucion.c
*
* \brief    Experiencia 2 de laboratorio DSP ELO314
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
// Constantes
#define AUDIOBUFFERSIZE          (6000)
#define RMSBUFFERSIZE            (1)

/******************************************************************************
**      MODULE DATATYPES
******************************************************************************/


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

/*---------------------------------------------------------------------------*/
/* BUFFER DE AUDIO E ÍNDICES */
/*---------------------------------------------------------------------------*/
//#pragma DATA_SECTION(audioBufferR,".EXT_RAM")
//#pragma DATA_SECTION(audioBufferL,".EXT_RAM")
float           audioBufferR[AUDIOBUFFERSIZE];
float           audioBufferL[AUDIOBUFFERSIZE];
uint32_t        idxAudioBufferRHead = 0, idxAudioBufferLHead = 0;
uint32_t        idxAudioBufferRRead = 0, idxAudioBufferLRead = 0;

/*---------------------------------------------------------------------------*/
/* CÓMPUTO RMS Y BUFFERS AUXILIARES */
/*---------------------------------------------------------------------------*/

float           valor_rms_aux =  0;
float           valor_rms =  0;
float           valor_rms_export =  0;

uint32_t        bisquad_idx = 0, dsp_counter = 0, dsp_counter2 = 0;

/*---------------------------------------------------------------------------*/
/* GENERACIÓN DE SEALES */
/*---------------------------------------------------------------------------*/
/* Coeficientes para biquiad con polinomio de denominador mónico en z^-1 */
float bq1B0 = 0.051342456225139;
float bq1A1 = -1.997362212708321;
float bq1A2 = 1.0;

float bq2B0 = 0.064671642929027;
float bq2A1 = 0;
float bq2A2 = 1.0;

float freqs[8] = {
                  -1.989455808755079,
                  -1.986712411082089,
                  -1.983270314403442,
                  -1.981224670513680,
                  -1.976349838220561,
                  -1.970218652309548,
                  -1.962499595766148,
                  -1.957918389969887
};

/* Variables de entrada y salida de biquads */
float bq1_input[2] = {0.0,0.8};
float bq1_output[3] = {0.0,0.0,0.0};

float bq2_input[2] = {0.0,0.8};
float bq2_output[3] = {0.0,0.0,0.0};

/*---------------------------------------------------------------------------*/
/* VARABLES OVERDRIVE */
/*---------------------------------------------------------------------------*/
float overdriveInput = 0;
float overdriveOutput = 0;

float overdriveInputGain   =  1.0;
float overdriveOutputGain  =  1.0;
float overdriveBeta        =  0.05;
float overdriveAlpha       =  0.2;

/*---------------------------------------------------------------------------*/
/* DELAY MULTITP */
/*---------------------------------------------------------------------------*/


/*---------------------------------------------------------------------------*/
/* EFECTO DE AUDIO ELEFIDO:  */
/*---------------------------------------------------------------------------*/


/******************************************************************************
**      PRIVATE FUNCTION DECLARATIONS (PROTOTYPES)
******************************************************************************/

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
        /* BUFFERS LINEALES Y CIRCULARES */
        /*-------------------------------------------------------------------*/
        /* Buffer lineal */
        // float valor_final = audioBufferL[AUDIOBUFFERSIZE-1];

        /* for(idxAudioBufferLHead = AUDIOBUFFERSIZE-1; idxAudioBufferLHead > 0 ; idxAudioBufferLHead--)
            audioBufferL[idxAudioBufferLHead] = audioBufferL[idxAudioBufferLHead-1];
        audioBufferL[0] = floatCodecInputR; */

        /* Buffer circular */

        // Procesamiento
        idxAudioBufferRRead = (idxAudioBufferRHead + AUDIOBUFFERSIZE - 8000 ) % AUDIOBUFFERSIZE;
        float valor_final_c = audioBufferL[idxAudioBufferRRead];

        // Actualizacion del buffer
        audioBufferL[idxAudioBufferRHead] = floatCodecInputR;
        // Actualizacion de la cabeza del buffer
        idxAudioBufferRHead = (idxAudioBufferRHead + 1) % AUDIOBUFFERSIZE;

        /* Medición de tiempo de ejecución */
        DLU_toc();

        /*-------------------------------------------------------------------*/
        // USO DE ESTADO DE PULSADOR USER1 PARA ACTIVAR LED
        /*-------------------------------------------------------------------*/
        //DLU_writeLedD4(DLU_gPbUser1);
        // Obtención de valores de estados para cambiar estado de leds
        if ( DLU_readToggleStatePB1() )
            DLU_writeLedD5(LED_ON);
        else
            DLU_writeLedD5(LED_OFF);

        if ( DLU_readToggleStatePB2() )
            DLU_writeLedD6(LED_ON);
        else
            DLU_writeLedD6(LED_OFF);

        if ( DLU_readToggleStatePB12() )
            DLU_writeLedD7(LED_ON);
        else
            DLU_writeLedD7(LED_OFF);

        /*-------------------------------------------------------------------*/
        /* OSCILADORES BIQUAD */
        /*-------------------------------------------------------------------*/
        /* Actualización de biquad 1 */
        bq1_input[0] = bq1_input[1];
        bq1_input[1] = 0.0;

        bq1_output[2] = bq1_output[1];
        bq1_output[1] = bq1_output[0];
        bq1_output[0] = (bq1B0 * bq1_input[0]) - (bq1A1 * bq1_output[1]) - (bq1A2 * bq1_output[2]);

        /* Actualización de biquad 2 */
        bq2_input[0] = bq2_input[1];
        bq2_input[1] = 0.0;

        bq2_output[2] = bq2_output[1];
        bq2_output[1] = bq2_output[0];

        // oscilación de frecuencias
        dsp_counter = (dsp_counter + 1) % 8000; // 8000 = fs/2 <=> 0.5 segundos

        bq2A1 = freqs[bisquad_idx];

        if (dsp_counter == 0) {
            bisquad_idx = (bisquad_idx+1) % 8;
        }

        bq2_output[0] = (bq2B0 * bq2_input[0]) - (bq2A1 * bq2_output[1]) - (bq2A2 * bq2_output[2]);

        /*-------------------------------------------------------------------*/
        /* CALCULO RMS */
        /*-------------------------------------------------------------------*/

        valor_rms_aux = floatCodecInputR*floatCodecInputR + valor_rms_aux;

        dsp_counter2 = (dsp_counter2 + 1) % 256;

        if (dsp_counter2 == 0) {
            valor_rms = sqrt(valor_rms_aux) - 0.3;
            valor_rms_aux = 0;
        }

        valor_rms_export = bq2_output[0]*valor_rms;

        /*-------------------------------------------------------------------*/
        /* PARA VISUALIZAR EN GRÁFICO */
        /*-------------------------------------------------------------------*/
        DLU_enableSynchronicSingleCaptureOnAllGraphBuff();
        DLU_appendGraphBuff1(floatCodecInputL);
        DLU_appendGraphBuff2(bq1_output[0]);

        /*-------------------------------------------------------------------*/
        /* ESCRITURA EN SALIDA DEL CODEC */
        /*-------------------------------------------------------------------*/
        floatCodecOutputL = valor_rms_export; //test; //valor_final;
        floatCodecOutputR = valor_rms_export; //floatCodecInputR; //audioBufferL[AUDIOBUFFERSIZE-1];

        outSaturationStat = DLU_writeCodecOutputs(floatCodecOutputL,floatCodecOutputR);
        DLU_writeLedD4((PB_INT_TYPE)outSaturationStat);

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

   /* Loop infinito a espera de interrupción del Codec */
    while(1);
}

/******************************************************************************
**      END OF SOURCE FILE
******************************************************************************/
