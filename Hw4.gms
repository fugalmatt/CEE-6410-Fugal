$ontext
CEE 6410 - Water Resources Systems Analysis
Problem 3 from chapter 2 of Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)

THE PROBLEM:

An aqueduct constructed to supply water to industrial users has an excess capacity in the
months of June, July, and August of 14,000 acft, 18,000 acft, and 6,000 acft, respectively.
It is proposed to develop not more than 10,000 acres of new land by utilizing the excess
aqueduct capacity for irrigation water deliveries. Two crops, hay and grain, are to be
grown. Their monthly water requirements and expected net returns are given in the following table:

        June    July    August  Return($/acre)
Hay     2       1       1       100     
Grain   1       2       0       120


                Determine the optimal planting for the two crops.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Matthew Fugal
fugalmatt@gmail.com
September 30, 2024
$offtext

* 1. DEFINE the SETS
SETS plnt crops growing /Hay, Grain/
     res resources /JuneW, JulyW, AugustW, Land/;

* 2. DEFINE input data
PARAMETERS
   c(plnt) Objective function coefficients ($ per acre)
         /Hay 100,
         Grain 120/
   b(res) Right hand constraint values (per resource)
          /JuneW 14000
          JulyW 18000
          AugustW 6000
          Land 10000/;

TABLE A(plnt,res) Left hand side constraint coefficients
                 JuneW  JulyW   AugustW Land
 Hay             2      1       1       1
 Grain           1      2       0       1;

* 3. DEFINE the variables
VARIABLES X(plnt) plants planted (acres)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   RES_CONSTRAIN(res) Resource Constraints;

PROFIT..                 VPROFIT =E= SUM(plnt,c(plnt)*X(plnt));
RES_CONSTRAIN(res) ..    SUM(plnt,A(plnt,res)*X(plnt)) =L= b(res);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL PLANTING /PROFIT, RES_CONSTRAIN/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;

* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANTING USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
