function dp=fu1(x,y);
dp=zeros(2,1) ; % dp wird als Spaltenvektor generiert
dp(1)=y(2);
dp(2)=-3*y(2)-2*y(1);

% Aufruf:
% ta=0; te=10; y0=[0 1];
% [t,y]=ode23(@fu1,[ta te],y0); 