$onText
CEE 6410
Homework 5

Matthew Fugal
fugalmatt@gmail.com
October 8, 2024
$offText

Sets
    month /m1*m6/;
    
Parameters
    hydro_benefit(month)
         /m1 1.6, m2 1.7, m3 1.8, m4 1.9, m5 2.0, m6 2.0/
    irr_benefit(month)
         /m1 1.0, m2 1.2, m3 1.9, m4 2.0, m5 2.2, m6 2.2/
    inflow(month)
         /m1 2, m2 2, m3 3, m4 4, m5 3, m6 2/;
         
Scalars
    initial_storage /5/
    hydro_cap /4/
    storage_cap /9/;

VARIABLES
    storage(month)
    spill(month)
    hydropower(month)
    irrigation(month)
    vprofit;

POSITIVE VARIABLES storage, irrigation, spill, hydropower;

EQUATIONS
    Reservoir_storage(month)
    Reservoir_capacity(month)
    Hydro_capacity(month)
    Irrigation_use(month)
    Storage_final
    Profit;

Reservoir_storage(month)..  storage(month) =E= storage(month-1)$(ord(month)>1) + inflow(month) - spill(month) - hydropower(month) + initial_storage$(ord(month)=1);

Reservoir_capacity(month).. storage(month) =L= storage_cap;

Storage_final..             storage("m6") =G= initial_storage;

Hydro_capacity(month)..     hydropower(month) =L= hydro_cap;

Irrigation_use(month)..     irrigation(month) =E= hydropower(month) + spill(month) - 1;

Profit..                    vprofit =E= SUM(month, irrigation(month) * irr_benefit(month)) + SUM(month, hydropower(month) * hydro_benefit(month));

MODEL reservoir /all/;

SOLVE reservoir USING LP MAXIMIZING vprofit;
