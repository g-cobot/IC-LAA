%ConfigurarImagem

%Configurando a imagem
%Abra a imagem depois rode o seguinte comando
figura=gcf

%Estado posicoes
ndivyP=[5; 6; 6];
ndivxP=[5; 5; 5];

YiniP=[-0.3;-0.4;-0.5];
YfimP=[0.3;0.1;0.1];

XiniP=[0;0;0];
XfimP=[28;28;28];

%Estado Velocidades
ndivyV=[5; 4; 4];
ndivxV=[5; 5; 5];
YiniV=[-0.7;-0.2;-0.4];
YfimV=[0.7;1.3;0.2];

XiniV=[0;0;0];
XfimV=[28;28;28];

textP=['$\theta_4';'$\theta_2';'$\theta_1'];
textV=['$\dot{\theta}_4';'$\dot{\theta}_2';'$\dot{\theta}_1'];
textU=['$F_1';'$F_2'];

%Tamanho da fonte
fs=18.00;

for i=1:3
    figura.Children(i).FontSize=fs
    %Arrumando Title Labels
    figura.Children(i).Title.String=''
    figura.Children(i).Title.Interpreter='latex'
    %Arrumando tick interpreter
    figura.Children(i).TickLabelInterpreter='latex'
    %Arrumando o eixo X
    figura.Children(i).XGrid=1
    figura.Children(i).XLabel.Interpreter='latex'
    figura.Children(i).XLabel.String=''
    %Arrumando o eixo Y
    figura.Children(i).YGrid=1
    figura.Children(i).YLabel.Interpreter='latex'
    figura.Children(i).Children.Color ='black'
end

for i=4:6
    figura.Children(i).FontSize=fs
    %Arrumando Title Labels
    figura.Children(i).Title.String=''
    figura.Children(i).Title.Interpreter='latex'
    %Arrumando tick interpreter
    figura.Children(i).TickLabelInterpreter='latex'
    %Arrumando o eixo X
    figura.Children(i).XGrid=1
    figura.Children(i).XLabel.Interpreter='latex'
    figura.Children(i).XLabel.String=''
    %Arrumando o eixo Y
    figura.Children(i).YGrid=1
    figura.Children(i).YLabel.Interpreter='latex'
    figura.Children(i).Children(1).Color ='red'
    figura.Children(i).Children(2).Color ='black'
end

for i=1:3
    figura.Children(i+3).YTick= linspace(YiniP(i),YfimP(i),ndivyP(i))
    figura.Children(i+3).YLim= [YiniP(i) YfimP(i)]
    figura.Children(i+3).XTick= linspace(XiniP(i),XfimP(i),ndivxP(i))
    figura.Children(i+3).XLim= [XiniP(i) XfimP(i)]
    figura.Children(i+3).YLabel.String={'[rad]'}
end

for i=1:3
    figura.Children(i).YTick= linspace(YiniV(i),YfimV(i),ndivyV(i))
    figura.Children(i).YLim= [YiniV(i) YfimV(i)]
    figura.Children(i).XTick= linspace(XiniV(i),XfimV(i),ndivxV(i))
    figura.Children(i).XLim= [XiniV(i) XfimV(i)]
    figura.Children(i).YLabel.String=strcat(textV(i,:),'\hspace{0.5em}$[rad/s]')
end

for i=1:3:4
    figura.Children(i).XLabel.String='Tempo [s]'
end


texto1=['$\theta_{4,ss}$';'$\theta_{2,ss}$';'$\theta_{1,ss}$']
texto2=['$\theta_4$';'$\theta_2$';'$\theta_1$']
j=1;
for i=4:2:8
    legend1 = legend(figura.Children(i),'show');
    set(legend1,'Interpreter','latex','FontSize',16);
    legend1.String={texto2(j,:),texto1(j,:)};
    if i==6
       legend1.Location='southeast';
    else
       legend1.Location='northeast';
    end
    j=j+1;
end
