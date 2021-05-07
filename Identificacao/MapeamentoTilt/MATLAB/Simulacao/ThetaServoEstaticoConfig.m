%ConfigurarImagem

%Configurando a imagem
%Abra a imagem depois rode o seguinte comando
figura=gcf
ndivy=[10];
ndivx=[9]; 
Xini=[650];
Xfim=[2250];

Yini=[0];
Yfim=[180];
text=['$\theta_{servo}'];

%Arrumando a Legenda
%ligando a legenda
legend('Resultado experimental','Curva ajustada')
legend('Interpreter','latex')
legend('location','northwest')
%Tamanho da fonte
fs=27.25;
figura.Children(2).FontSize=fs
%Arrumando Title Labels
figura.Children(2).Title.String=''
figura.Children(2).Title.Interpreter='latex'
%Arrumando tick interpreter
figura.Children(2).TickLabelInterpreter='latex'
%Arrumando o eixo X
figura.Children(2).XGrid=1
figura.Children(2).XTick= linspace(Xini,Xfim,ndivx)
figura.Children(2).XLim= [Xini Xfim]
figura.Children(2).XLabel.String='PPM $\hspace{0.5em}$[ms]'
figura.Children(2).XLabel.Interpreter='latex'
%Arrumando o eixo Y
figura.Children(2).YGrid=1
figura.Children(2).YTick= linspace(Yini,Yfim,ndivy)
figura.Children(2).YLim= [Yini Yfim]
figura.Children(2).YLabel.String=strcat(text,'\hspace{0.5em}[{}^\circ]$')
figura.Children(2).YLabel.Interpreter='latex'
figura.Children(2).Children(1).Color ='black'
figura.Children(2).Children(2).Color ='black'
