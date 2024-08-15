# Two User Scripts

This folder contains scripts for generating results for two sensors. While some notation varies between scripts, the following variable names are used consistently for representing the problem parameters:

- `P1` and `P0` are the source distribution variables
- `Ew` and `Es` are the sensor crossover probabilities (`Ew` less than `Es`)
- `N0` is the noise power
- `Pw` and `Ps` are the active power allocations for each sensor (expressed as square root of average power)
- `theta` is the rotation angle between the individual constellation (in radians)
- `testVals` is an array of test values that a script will be looping over (e.g. SNR or power allocations)
- `trials` is the number of simulated source bits to send over the channel when generating simated error probability

## BaseSetup.m
This script is where the parameters `P1`, `Ew` and `Es` should be defined. This script also calculates many essential variables for the calculations, such as constellation points and conditional probabilities, so it is used as a setup setup step in nearly every other script.

## MAPDecodingRegions.m
This script visualizes the detection regions for a specified parameter set. The parameters which can be changed are `theta`, `N0`, `Pw` and `Ps`.

## DecisionBoundaryPlotting
This script visualizes the decision boundaries as a function of `Ps`. The parameters which can be changed are `N0`, `Pw` and `testVals`. In addition, other parameters can be varied by changing the code inside the testing loop.

## CaseThreshPlots.m
This script visualizes the case types as a function of `Ew` and `Es`. The only parameter which can be changed is `P1`.

## ErrorTheta0Calculate.m
This script calculates the error probability as a function of `Ps`. The parameters which can be changed are `N0`, `Pw` and `testVals`. In addition, other parameters can be varied by changing the code inside the testing loop.

## ErrorTheta0VarySNR.m
This script calculates the error probability of various signaling schemes, including the optimal constellation design, as a function of `Ps`. The parameters which can be changed are `testVals`, `PwMax` and `PsMax` (maximum power allocations).

## ErrorTheta0HeatMap.m
This script visualized the error probability as a heat map with respect to `Pw` and `Ps`. The parameters which can be changed are `N0`, `PwVals` and `PsVals` (values to test over). Additionally, this script can be used to create an error probability heat map with respect to `Ew` and `Es` by commenting out the appropriate lines inside of the testing loop.

## ErrorTesting.m
This script runs simulations to approximate error probability over varying `Ps`. The parameters which can be changed are `testVals`, `N0`, `Pw` and `theta`. In addition, other parameters can be varied by changing the code inside the testing loop.
