%ConfigurarImagem

%Configurando a imagem
%Abra a imagem depois rode o seguinte comando
figura=gcf
i=1
ndivy=5
ndivx=8
Xini=0;
Xfim=12.5;

Yini=-100;
Yfim=100;
text='$\overline{PPM}'
%Tamanho da fonte
fs=27.25;
figura.Children(1).FontSize=fs
%Arrumando Title Labels
figura.Children(1).Title.String=''
figura.Children(1).Title.Interpreter='latex'
%Arrumando tick interpreter
figura.Children(1).TickLabelInterpreter='latex'
%Arrumando o eixo X
figura.Children(1).XGrid=1
figura.Children(1).XLabel.String='Tempo\hspace{0.5em}[s]'
figura.Children(1).XLabel.Interpreter='latex'
figura.Children(1).XTick= linspace(Xini(i),Xfim(i),6)
figura.Children(1).XLim= [Xini(i) Xfim(i)]
%Arrumando o eixo Y
figura.Children(1).YGrid=1
figura.Children(1).YTick= linspace(Yini(i),Yfim(i),ndivy(i))
figura.Children(1).YLim= [Yini(i) Yfim(i)]
figura.Children(1).YLabel.String=strcat(text(i,:),'\hspace{0.5em}$[ms]')
figura.Children(1).YLabel.Interpreter='latex'
figura.Children(1).Children(1,:).Color ='black'
