# Formation-of-Visual-Object-Representations
MATLAB code for the master's thesis "Formation of Neural Object Representations Through Repeated Visual Experience" by Johanna Fiege, submitted to Ludwig-Maximilians-University Munich, August 2026.

## Overview

This repository contains the analyses codes for time-resolved multivariate decoding of category representations of familiar and novel objects and familiarity representations from EEG data in infants and children. Decoding accuracy is computed per subject and time point, then tested for significance against chance level (50 %) using cluster-based permutation testing. Dependent variables were tested using t-tests to examine Hypotheses.
Two age groups are analyzed (`Children_100`, `Infants_100`), each across four conditions (`cat`, `fam`, `novel`, `familiarity`).

## Repository Structure

- `scripts` (containing analysis scripts for decoding in time, time-generalization, statistics extraction, plotting, analyses including hypotheses testing and exploratory analyses)
- `functions` (containing customized functions, swtest.mat by BenSaïda, A. (2014), as well as functions provided by Xie, S. (2022) see Acknowledgements)
- `results` (containing Decoding accuracy matrices per subject, results tables, Plots)

Clone this repository:  
```
git clone https://github.com/Jojoo16/Masterthesis-Formation-of-Visual-Object-Representations/tree/main

```    
At the top of each script, update projectRoot to point to wherever repository is cloned

## Required toolboxes

For running decoding analyses the LIBSVM toolbox is required.  
Install here: https://github.com/cjlin1/libsvm

## Acknowledgements

Scripts for decoding in time and time-generalization analyses were adapted from the codes which have been made available by Xie, Siying (2022, https://github.com/siyingxie/VCR_infant).

Preprocessing Pipeline of EEG data was created by Mirjam Marx (https://github.com/neuroglia) 

Supervised by Prof. Dr. Dr. Moritz Köster, University of Regensburg



