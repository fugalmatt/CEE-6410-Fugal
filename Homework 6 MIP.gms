$ontext
CEE 6410 - Water Resources Systems Analysis
Matthew Fugal
fugalmatt@gmail.com
October 14, 2024
$offtext

* 1. DEFINE the SETS
SETS src water supply sources /sr "small reservoir", lr "large reservoir", pu "lower river pump"/;

* 2. DEFINE input data
PARAMETERS
   CapCost(src) capital cost ($ to build)
         /sr 6000,
          lr 10000,
          pu 8000/
   OpCost(src) operating cost ($ per ac-ft)
         /sr 0,
          lr 0,
          pu 20/
   MaxCapacity(src) Maximum capacity of source when built (ac-ft per year)
          /sr 300,
           lr 700,
           pu 803/
   MinUse(src) Minimum required use of source when built (ac-ft per year)
          /sr 0,
           lr 0,
           pu 0/

   IntUpBnd(src) Upper bound on integer variables (#)
          /sr 1,
           lr 1,
           pu 1/
   IntLowBnd(src) Lower bound on integer variables (#)
           /sr 0,
            lr 0,
            pu 0/;

* 3. DEFINE the variables
VARIABLES I(src) binary decision to build or do prject from source src (1=yes 0=no)
          X(src) volume of water provided by source src (ac-ft per year)
          TCOST  total capital and operating costs of supply actions ($);

BINARY VARIABLES I;
* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   COST            Total Cost ($) and objective function value
   MaxCap(src)     Maximum capacity of source when built (ac-ft per year)
   MinReqUse(src)  Minimum required use of source when built (ac-ft per year)
   MeetDemand      Meet demand (ac-ft per year)
   IntUpBound(src) Upper bound on interger variables (number)
   IntLowBound(src) Lower bound on integer variables (number);

COST..                 TCOST =E= SUM(src,CapCost(src)*I(src) + OpCost(src)*X(src));
MaxCap(src) ..           X(src) =L= MaxCapacity(src)*I(src);
MinReqUse(src) ..        X(src) =G= MinUse(src)*I(src);
MeetDemand ..            sum(src,X(src)) =G= TotDemand;
IntUpBound(src) ..       I(src) =L= IntUpBnd(src);
IntLowBound(src) ..      I(src) =G= IntLowBnd(src);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL WatSupplyRelaxed /ALL/;

* 6. Solve the Model as an LP (relaxed IP)
SOLVE WatSupplyRelaxed USING MIP MINIMIZING TCOST;

DISPLAY X.L, I.L, TCOST.L;

* Dump all input data and results to a GAMS gdx file
Execute_Unload "Ex6-3-integer.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls Ex6-3-integer.gdx"
