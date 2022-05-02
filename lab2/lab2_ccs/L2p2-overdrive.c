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


/*---------------------------------------------------------------------------*/
/* GENERACIÓN DE SEALES */
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* VARABLES OVERDRIVE */
/*---------------------------------------------------------------------------*/
float overdriveInput = 0;
float overdriveOutput = 0;

float overdriveInputGain   =  3.0;
float overdriveOutputGain  =  1.0;
float overdriveBeta        =  0.05;
float overdriveAlpha       =  0.1;

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
        /* OVERDRIVE */
        /*-------------------------------------------------------------------*/

        int sign = 1;

        overdriveInput = floatCodecInputR*overdriveInputGain;

        if (overdriveInput < 0) {
            sign = -1;
        }

        if ( abs(overdriveInput) >= overdriveAlpha ) {
            overdriveOutput = overdriveBeta*overdriveInput + sign*(1 - overdriveBeta)*overdriveAlpha;
        } else {
            overdriveOutput = overdriveInput;
        }


        /*-------------------------------------------------------------------*/
        /* PARA VISUALIZAR EN GRÁFICO */
        /*-------------------------------------------------------------------*/
        DLU_enableSynchronicSingleCaptureOnAllGraphBuff();
        DLU_appendGraphBuff1(floatCodecInputL);
        DLU_appendGraphBuff2(floatCodecInputR);

        /*-------------------------------------------------------------------*/
        /* ESCRITURA EN SALIDA DEL CODEC */
        /*-------------------------------------------------------------------*/
        floatCodecOutputL = overdriveOutput*overdriveOutputGain; //test; //valor_final;
        floatCodecOutputR = overdriveOutput*overdriveOutputGain; //floatCodecInputR; //audioBufferL[AUDIOBUFFERSIZE-1];

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
