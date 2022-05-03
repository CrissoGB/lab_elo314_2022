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
#define AUDIOBUFFERSIZE          (32000)
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
float           audioBufferR[AUDIOBUFFERSIZE] = {0};
float           audioBufferL[AUDIOBUFFERSIZE] = {0};
uint32_t        idxAudioBufferRHead = 0, idxAudioBufferLHead = 0;
uint32_t        idxAudioBufferRRead = 0, idxAudioBufferLRead = 0;

/*---------------------------------------------------------------------------*/
/* CÓMPUTO RMS Y BUFFERS AUXILIARES */
/*---------------------------------------------------------------------------*/


/*---------------------------------------------------------------------------*/
/* GENERACIÓN DE SEALES */
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* VARABLES OVERDRIVE */
/*---------------------------------------------------------------------------*/
float overdriveInput = 0;
float overdriveOutput = 0;

float overdriveInputGain   =  1.0;
float overdriveOutputGain  =  1.0;
float overdriveBeta        =  0.05;
float overdriveAlpha       =  0.1;

/*---------------------------------------------------------------------------*/
/* DELAY MULTITP */
/*---------------------------------------------------------------------------*/
#define Fs          (16000)
#define length      (0.200)
#define N           (10)

int M               = Fs*length;

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
        /* MULTI-TAP DELAY */
        /*-------------------------------------------------------------------*/

        audioBufferL[idxAudioBufferRHead] = floatCodecInputR;
        float v_delay = 0;
        float b = 0.35;

        int i = 0;
        for (i = 0; i < N; ++i) {
            idxAudioBufferRRead = (idxAudioBufferRHead + AUDIOBUFFERSIZE - M*(i+1) ) % AUDIOBUFFERSIZE;
            v_delay = v_delay + b*audioBufferL[idxAudioBufferRRead];
            b = b*b;    // comentar esta línea mantiene el valor de b constante
        }

        float v_delay_exp = audioBufferL[idxAudioBufferRHead] + v_delay;

        idxAudioBufferRHead = (idxAudioBufferRHead + 1) % AUDIOBUFFERSIZE;


        /*-------------------------------------------------------------------*/
        /* PARA VISUALIZAR EN GRÁFICO */
        /*-------------------------------------------------------------------*/
        DLU_enableSynchronicSingleCaptureOnAllGraphBuff();
        DLU_appendGraphBuff1(floatCodecInputL);
        DLU_appendGraphBuff2(floatCodecOutputR);

        /*-------------------------------------------------------------------*/
        /* ESCRITURA EN SALIDA DEL CODEC */
        /*-------------------------------------------------------------------*/
        floatCodecOutputL = v_delay_exp; //test; //valor_final;
        floatCodecOutputR = v_delay_exp; //floatCodecInputR; //audioBufferL[AUDIOBUFFERSIZE-1];

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
