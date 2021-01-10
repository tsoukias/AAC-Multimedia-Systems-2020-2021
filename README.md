# Simplified AAC (Advanced Audio Coding) - Multimedia Systems

This repository contains the assignment for the Academic Courses "Multimedia Systems" taught in the winter semester of 2020-2021 in Aristotle University of Thessaloniki - Electrical and Computer Engineering Department. 

The assignment targets on the creation of an encoder/ decoder by the standards of Advanced Audio Coding (AAC). Variations of the AAC are used by many international standards such as MPEG-2, MPEG-4, H.264 etc. The version developed for this assignment is more similar to the 3GPP TS 26,403 specifications where some processing steps are missing. An exception is the
psychoacoustic model, which is a slightly simplified version of MPEG AAC. Despite this, it leads to quite good results. 

The encoder/ decoder was developed in three levels that can be found in their respective folders. Each folder contains both the encoder and the decoder and can be tested with the function demoAACx(). The results folder contains the output ''.wav" files for each level. 

Note that the code is designed to work with 2 channel ".wav" files with 48KHz sampling frequency. 

