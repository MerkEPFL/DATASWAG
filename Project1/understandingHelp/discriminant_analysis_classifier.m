%% loading Fisher Iris dataset
clear all; close all; clc;

load fisheriris

PL = meas(:,3); %petal lenght
PW = meas(:,4); %petal width

%% plotting data

%plotting by petal lenght vs width
figure;
h1 = gscatter(PL,PW,species,'krb','ov^',[],'off');
h1(1).LineWidth = 2;
h1(2).LineWidth = 2;
h1(3).LineWidth = 2;
legend('Setosa','Versicolor','Virginica','Location','best')
hold on

%% CREATING A LINEAR CLASSIFIER

X = [PL,PW]; % ogni riga sono le 150 observations e ogni colonna saranno le differenti features
Md1Linear = fitcdiscr(X,species); %species contiene le labels


%% EXPLORING THE CLASSIFIER (just to capire)

%importante proprietà del modello è Coeffs
classCoeff = Md1Linear.Coeffs;

% Coeffs contiene per ogni coppia di classi (quindi se ci sono 3 classi
% conterrà le coppie (1,2), (1,3) e (2,3) e per ogni coppia continee
% i diversi coefficenti per segnare una retta che divide al meglio i due
% gruppi (per retta si intende k + c1*x1 + c2*x2) dove x1 e x2 possono
% essere visti come x e y visto che per ora siamo in due dimensioni, ma poi
% è sempre meglio chiamarli come k + c1*x1 + ... + cn*xn perché saranno
% iperpiani per dimensioni più grandi di 2

% per esempio per la coppia (2,3):
coeff2_3 = Md1Linear.Coeffs(2,3);
K = Md1Linear.Coeffs(2,3).Const; % questo è il coefficente costante
L = Md1Linear.Coeffs(2,3).Linear; % questi sono i due c1 e c2

% plottiamo la retta
f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
h2 = ezplot(f,[.9 7.1 0 2.5]);
h2.Color = 'r';
h2.LineWidth = 2;

% ora facciamo la stessa cosa per la coppia (1,2)
K = Md1Linear.Coeffs(1,2).Const;
L = Md1Linear.Coeffs(1,2).Linear;

f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
h3 = ezplot(f,[.9 7.1 0 2.5]);
h3.Color = 'k';
h3.LineWidth = 2;
axis([.9 7.1 0 2.5])
xlabel('Petal Length')
ylabel('Petal Width')
title('{\bf Linear Classification with Fisher Training Data}')

%% CREATING A QUADRATIC CLASSIFIER

MdlQuadratic = fitcdiscr(X,species,'DiscrimType','quadratic');


%% EXPLORING THE CLASSIFIER

%plotting by petal lenght vs width
figure;
h1 = gscatter(PL,PW,species,'krb','ov^',[],'off');
h1(1).LineWidth = 2;
h1(2).LineWidth = 2;
h1(3).LineWidth = 2;
legend('Setosa','Versicolor','Virginica','Location','best')
hold on

%recupero i coefficenti per la versione quadratica del classifier per la
%coppia (2,3)
K = MdlQuadratic.Coeffs(2,3).Const;
L = MdlQuadratic.Coeffs(2,3).Linear;
Q = MdlQuadratic.Coeffs(2,3).Quadratic;

%e plotto
f = @(x1,x2) K + L(1)*x1 + L(2)*x2 + Q(1,1)*x1.^2 + ...
    (Q(1,2)+Q(2,1))*x1.*x2 + Q(2,2)*x2.^2;
h2 = ezplot(f,[.9 7.1 0 2.5]);
h2.Color = 'r';
h2.LineWidth = 2;

%ora per la coppia (1,2)
K = MdlQuadratic.Coeffs(1,2).Const;
L = MdlQuadratic.Coeffs(1,2).Linear;
Q = MdlQuadratic.Coeffs(1,2).Quadratic;


%e plotto
f = @(x1,x2) K + L(1)*x1 + L(2)*x2 + Q(1,1)*x1.^2 + ...
    (Q(1,2)+Q(2,1))*x1.*x2 + Q(2,2)*x2.^2;
h3 = ezplot(f,[.9 7.1 0 1.02]); % Plot the relevant portion of the curve.
h3.Color = 'k';
h3.LineWidth = 2;
axis([.9 7.1 0 2.5])
xlabel('Petal Length')
ylabel('Petal Width')
title('{\bf Quadratic Classification with Fisher Training Data}')
hold off

