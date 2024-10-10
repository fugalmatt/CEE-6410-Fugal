$onText
CEE 6410
Homework 5

Matthew Fugal
fugalmatt@gmail.com
October 8, 2024
$offText

SETS
    m  /m1*m6/
    mu /mu1*mu6/
    mh /mh1*mh6/
    mi /mi1*mi6/
    ms /ms1*ms6/
    rh /sh1*sh4/
    ri /si1*si4/;
    
PARAMETERS
    th(mh)
         /mh1 1.6, mh2 1.7, mh3 1.8, mh4 1.9, mh5 2.0, mh6 2.0/
    ts(ms)
         /ms1 0, ms2 0, ms3 0, ms4 0, ms5 0, ms6 0/
    ti(mi)
         /mi1 1.0, mi2 1.2, mi3 1.9, mi4 2.0, mi5 2.2, mi6 2.2/
    bh(rh)
         /sh1 7, sh2 9, sh3 12, sh4 16/
    bi(ri)
         /si1 6, si2 7, si3 9, si4 10/;

TABLE Ah(mh,rh)
                 sh1    sh2     sh3     sh4
 mh1             1      1       1       1
 mh2             0      1       1       1
 mh3             0      0       1       1
 mh4             0      0       0       1
 mh5             0      0       0       1
 mh6             0      0       0       1;

TABLE As(ms,rh)
                 sh1    sh2     sh3     sh4
 ms1             1      1       1       1
 ms2             0      1       1       1
 ms3             0      0       1       1
 ms4             0      0       0       1
 ms5             0      0       0       1
 ms6             0      0       0       1;

TABLE Ai(mi,ri)
                 si1    si2    si3     si4
 mi1             1      1      1       1
 mi2             0      1      1       1
 mi3             0      0      1       1
 mi4             0      0      0       1
 mi5             0      0      0       1
 mi6             0      0      0       1;

VARIABLES
    storage(m)
    spill(ms)
    hydropower(mh)
    irrigation(mi)
    totalinflow(rh)
    wateruse(mu)
    VPROFIT;

POSITIVE VARIABLES storage, irrigation, spill;

EQUATIONS
    PROFIT
    Totalusage(mu)
    Reservoirstorage(m)
    Irrigationuse(mi)
    RES_CONSTRAINH(rh)
    RES_CONSTRAINI(ri)
    Reservoircapacity(m)
    Hydrocapacity(mh);

Totalusage(mu)..        wateruse(mu) =E= SUM(ms, spill(ms)$(ord(ms)lt ord(mu))) + sum(mh, hydropower(mh)$(ord(mh)lt ord(mu)));

Reservoirstorage(m)..  storage(m) =E= SUM(rh, totalinflow(rh)$(ord(rh)= ord(m))) - sum(mu, wateruse(mu)$(ord(mu)= ord(m)));

Reservoircapacity(m).. storage(m) =L= 9;

Hydrocapacity(mh)..    hydropower(mh) =L= 4;

Irrigationuse(mi)..    irrigation(mi) =E= SUM(ms, spill(ms)) + SUM(mh, hydropower(mh)) - 1;

PROFIT..               VPROFIT =E= SUM(mi, ti(mi) * irrigation(mi)) + SUM(mh, th(mh) * hydropower(mh));

RES_CONSTRAINH(rh)..   SUM(mh, Ah(mh, rh) * hydropower(mh)) + SUM(ms, As(ms, rh) * spill(ms)) =L= bh(rh);

RES_CONSTRAINI(ri)..   SUM(mi, Ai(mi, ri) * irrigation(mi)) =L= bi(ri);

MODEL PLANTING /Totalusage, Reservoirstorage, Reservoircapacity, Irrigationuse, PROFIT, RES_CONSTRAINH, RES_CONSTRAINI, Hydrocapacity/;

SOLVE PLANTING USING LP MAXIMIZING VPROFIT;
