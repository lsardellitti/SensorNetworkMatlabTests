% 1 is the weak but better channel, 2 is strong but worse channel
P1 = 0.19; % these are power ratios to the noise
P2 = 0.2;
E1 = 0.01;
E2 = 0.2;

% Success of sending S1 by itself
Pc1 = E1*(1-normcdf(P1)) + (1-E1)*normcdf(P1);

% Success of sending S2 by itself
Pc2 = E2*(1-normcdf(P2)) + (1-E2)*normcdf(P2);

% Success of sending both, decoding S1
Pc12 = E1*E2*(1 - normcdf(2*P2 + P1) + normcdf(P1+P2) - normcdf(P1))+...
       (1-E1)*E2*(normcdf(P1) + normcdf(P2-P1) - normcdf(2*P2-P1))+...
       E1*(1-E2)*(1 - normcdf(P1) + normcdf(2*P2-P1) - normcdf(P2 - P1))+...
       (1-E1)*(1-E2)*(normcdf(2*P2+P1) + normcdf(P1) - normcdf(P1+P2));

% Success of sending both, decoding S2
Pc21 = E1*E2*(1 - normcdf(P1+P2))+...
       (1-E1)*E2*(1 - normcdf(P2-P1))+...
       E1*(1-E2)*(normcdf(P2-P1))+...
       (1-E1)*(1-E2)*(normcdf(P1+P2));