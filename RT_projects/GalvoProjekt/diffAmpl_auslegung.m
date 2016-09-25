%%%% Differenzverstärker mit .... @!@MDB
% ue1 = 2.5V (ref)
% ue2 = signal 0...3V
clear all;
par=@(x,y) (x.*y)./(x+y);
par3=@(x,y,z) (x.^(-1)+y.^(-1)+z.^(-1)).^(-1);
syms R4 R9 R10 Uref Uoff Udac;

R10=27e3;

vrefFac=par(R10, R9)/(par(R10, R9)+R4); % == 21/25
voffFac=par(R4, R10)/(par(R4, R10)+R9); % == 2/15

%pretty(vrefFac);
%pretty(voffFac);

S=solve(vrefFac==21/25, voffFac==2/15);
sn=fieldnames(S);

ind=find(cellfun(@isnumeric, {R4,R9,R10}));
switch ind
    case 1 
        str=sprintf('R4 = %i:',R4);
    case 2 
        str=sprintf('R9 = %i:',R9);
    case 3
        str=sprintf('R10 = %i:',R10);
end


for k=1:length(sn)
    str=[str sprintf(':%s = %.0f',sn{k},eval(S.(sn{k})))];
end

strsplit(str,':')'

sol=solve(vrefFac==21/25);



return


clear all;
par=@(x,y) (x.*y)./(x+y);
par3=@(x,y,z) (x.^(-1)+y.^(-1)+z.^(-1)).^(-1);
syms R3 R4 R9 R10 Uref Uoff Udac;

vrefFac=par3(R3, R10, R9)/(par3(R3, R10, R9)+R4); % == 21/25
voffFac=par3(R4, R3, R10)/(par3(R4, R3, R10)+R9); % == 2/15

pretty(vrefFac)
pretty(voffFac)

[R4, R9, R10]=solve(vrefFac==21/25, voffFac==2/15, voffFac==vrefFac)

%[sol3, sol4]=solve(vrefFac==21/25, voffFac==2/15)
%sol=solve(vrefFac==21/25,R3)

return


Uplus=par3(R3, R10, R9)/(par3(R3, R10, R9)+R4)*Uref+par3(R4, R3, R10)/(par3(R4, R3, R10)+R9)*Uoff;

Ra=22e3;

usup=subs(Uplus, {'Uref','Uoff','R3','R4','R9','R10'},...
                 {2.5, Udac, 11*Ra, 1.1*Ra, 8*Ra, 8/7*Ra});
Udac=1.1/(1.1+11)*2.5;
usup1=subs(Uplus, {'Uref','Uoff','R3','R4','R9','R10'},...
                 {2.5, Udac, 11*Ra, 1.1*Ra, 8*Ra, 8/7*Ra});

eval(usup1)

Udac=[0:0.01:3];
plot(Udac,subs(usup,{'Udac'},{Udac}))
grid on

return

clear all;
R=10e3;

par=@(x,y) (x.*y)./(x+y);
set=[0:0.01:1];
 
plot(set,par(R.*(1-set),R.*set))
grid on;

return


clear all;
syms r1 posititve
syms r2 posititve
syms r3 posititve
syms r4 posititve
syms ue1 ue2;

VREF=1;

ua=ue2*(r1+r2)/r1*r4/(r3+r4)-ue1*r2/r1;
SOL2=solve(subs(ua,{'ue1','ue2'},{VREF, -2})==1,r2,r1,r3,r4)
SOL2=solve(subs(ua,{'ue1','ue2'},{VREF, 2})==1)


return


syms r1 r2 r3 r4 ue1 ue2;
VREF=2.5;

ue1=VREF;

r1=3;
r2=10;
SOL_R3 = solve((r1+r2)/r1*r4/(r3+r4)==1,r3)
subs((r1+r2)/r1*r4/(r3+r4),{'r3'},{SOL_R3})
SOL_R4 = solve((r1+r2)/r1*r4/(r3+r4)==1,r4)

%SOL_R4 = solve(subs((r1+r2)/r1*r4/(r3+r4),{'r3'},{SOL_R3})==1)

ua=ue2*(r1+r2)/r1*r4/(r3+r4)-ue1*r2/r1

out=subs(ua,{'ue2'},{[0:0.05:3]});
%plot(out)

return

clear all;
syms r1 posititve
syms r2 posititve
syms r3 posititve
syms r4 posititve
syms ue1 ue2;

VREF=2.5;

ua=ue2*(r1+r2)/r1*r4/(r3+r4)-ue1*r2/r1;
%subs(ua,{'ue2','ue1','r1','r2'},{VREF, 3, 1, 0.5})
SOL2=solve(subs(ua,{'ue1','ue2'},{VREF, -5})==5, r2)
SOL3=solve(subs(ua,{'ue1','ue2','r2'},{VREF, 5, SOL2})==5)


return
disp('new\n\n')
clear all;
syms r1 r2 r3 r4 ue1 ue2;
VREF=2.5;

ua=ue2*(r1+r2)/r1*r4/(r3+r4)-ue1*r2/r1;
SOL2=solve(subs(ua,{'ue1','ue2','r1'},{3, VREF, r2})==5, r2)
SOL3=solve(subs(ua,{'ue1','ue2','r1'},{3, VREF, r2})==5, r3)

%out=subs(ua,{'ue1','ue2','r3'},{2.5, [0:0.05:3], SOL3});
%plot(out)




