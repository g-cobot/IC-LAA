%ConfigurarImagem

%Configurando a imagem
%Abra a imagem depois rode o seguinte comando
figura=gcf

%Comando
ndivy=[5; 5];
ndivx=[5; 5];
Yini=[1.3;1.3]-1.7;
Yfim=[2.3;2.3]-1.7;

Xini=[0;0];
Xfim=[1400;1400];

textU=['$F_2';'$F_1'];

%Tamanho da fonte
fs=18.00;

for i=1:2
    figura.Children(i).FontSize=fs
    %Arrumando Title Labels
    figura.Children(i).Title.String=''
    figura.Children(i).Title.Interpreter='latex'
end

for i=1:2
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
    figura.Children(i).YLabel.String=strcat(textU(i,:),'\hspace{0.5em}[N]$')
    figura.Children(i).XLabel.String='$k$';
end