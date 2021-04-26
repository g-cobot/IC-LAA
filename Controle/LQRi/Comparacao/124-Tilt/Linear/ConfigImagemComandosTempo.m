%ConfigurarImagem

%Configurando a imagem
%Abra a imagem depois rode o seguinte comando
figura=gcf

%Comando
ndivy=[6; 6; 5; 5];
ndivx=[5; 5; 5; 5];
Yini=[-0.1;-0.1;1.5;1.5];
Yfim=[0.4;0.4;2.3;2.3];

Xini=[0;0;0;0];
Xfim=[28;28;28;28];

textF=['$\overline{F_2}';'$\overline{F_1}';];
textA=['$\alpha_2';'$\alpha_1'];
textUnitF=['[N]';'[N]'];
textUnitA=['[rad]';'[rad]'];

%Tamanho da fonte
fs=18.00;

for i=1:4
    figura.Children(i).FontSize=fs
    %Arrumando Title Labels
    figura.Children(i).Title.String=''
    figura.Children(i).Title.Interpreter='latex'
end

for i=1:4
    %Arrumando tick interpreter
    figura.Children(i).TickLabelInterpreter='latex'
    %Arrumando o eixo X
    figura.Children(i).XGrid=1
    figura.Children(i).XLabel.Interpreter='latex'
    figura.Children(i).XLabel.String=''
    %Arrumando o eixo Y
    figura.Children(i).YGrid=1
    figura.Children(i).YLabel.Interpreter='latex'
    figura.Children(i).Children(1,:).Color ='black'
    figura.Children(i).YTick= linspace(Yini(i),Yfim(i),ndivy(i))
    figura.Children(i).YLim= [Yini(i) Yfim(i)]
    figura.Children(i).XTick= linspace(Xini(i),Xfim(i),ndivx(i))
    figura.Children(i).XLim= [Xini(i) Xfim(i)]
end
for i=3:4
    figura.Children(i).YLabel.String=strcat(textF(i-2,:),'\hspace{0.5em}$',textUnitF(i-2,:))
end
for i=1:2
    figura.Children(i).YLabel.String=strcat(textA(i,:),'\hspace{0.5em}$',textUnitA(i,:))
    figura.Children(i).XLabel.String='Tempo [s]';
end