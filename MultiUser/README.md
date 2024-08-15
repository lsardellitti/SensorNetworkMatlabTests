# Multi User Scripts

This folder contains scripts for generating results for arbitrary number of sensors. While some notation varies between scripts, the following variable names are used consistently for representing the problem parameters:

- `P1` and `P0` are the source distribution variables
- `E` is a vector containing the sensor crossover probabilities
- `N` is the number of sensors
- `N0` is the noise power
- `P` is a vector of the active power allocations for each sensor (expressed as square root of average power)
- `Pmax` is a vector of maximum power allocations for each sensor
- `testVals` is an array of test values that a script will be looping over (e.g. SNR or power allocations)
- `trials` is the number of simulated source bits to send over the channel when generating simated error probability
- `useMAP` is a boolean variable respresenting whether the calculations will be done using MAP detection. The alternative is simplified (single decision boundary) detection.

## MultiUserSetup.m
This script is where the parameters `P1`, `N` and `E` should be defined. This script also calculates many essential variables for the calculations, such as constellation points and conditional probabilities, so it is used as a setup setup step in nearly every other script.

## ErrorCalcMultiUser.m
This script numerically calculates the error probability over varying SNR. The parameters which can be changed are `P`, `testVals` and `useMAP`. In addition, parameters other than SNR can be varied by changing the code inside the testing loop.

## ErrorTestingMulti.m
This script runs simulations to approximate error probability over varying SNR. The parameters which can be changed are `P`, `testVals` and `trials`. It can set to test either orthogonal channels or MAC depending on which version is commented out in the loop. In addition, parameters other than SNR can be varied by changing the code inside the testing loop.

## IncrementalOptimalPowerAlgorithm.m
This script runs the algorithmic optimization of power allocation. The parameters which can be changed are `N0`, `Pmax` and `P` (initial power). This scripts plots both the progression of power allocations, and error probability as the algorithm iterates.

## PaiwiseOptimization.m
This script runs the pairwise optimization of power allocation over varying SNR. The parameters which can be changed are `Pmax`, `testVals` and `useMAP`. In addition, parameters other than SNR can be varied by changing the code inside the testing loop.

## ErrorComparisonSNR.m
This script compares the results of the above scripts over SNR. The parameters which can be changed are `Pmax`, `Pstart` (initial power for algorithm) `testVals` and `trials` (trials for simulations).

## ErrorNCompare.m
This script compares the results of the above scripts over number of sensors. The parameters which can be changed are `NVals` (range of sensor values to test), `EVals` (range of sensor noise parameters),  `Pstart` (initial power for algorithm), `PVal` (max power allocation), `SNRVal` (SNR value to test) and `trials` (trials for simulations).