%Configurando a imagem
%Abra a imagem depois rode o seguinte comando
figura=gcf
i=1
Yinicio=[-1.2 -1.0]
Yfim=[1.2 1.0]
text=['$F_1';'$F_2'];
%Arrumando a Legenda
%ligando a legenda
legend('Curva aproximada','Resultado experimental')
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
figura.Children(2).XTick= 0:2.5:12.5
figura.Children(2).XLim= [0 12.5]
figura.Children(2).XLabel.String='Tempo\hspace{0.5em}[s]'
figura.Children(2).XLabel.Interpreter='latex'
%Arrumando o eixo Y
figura.Children(2).YGrid=1
figura.Children(2).YTick= linspace(Yinicio(i),Yfim(i),5)
figura.Children(2).YLim= [Yinicio(i) Yfim(i)]
figura.Children(2).YLabel.String=strcat(text(i,:),'\hspace{0.5em}[N]$')
figura.Children(2).YLabel.Interpreter='latex'
figura.Children(2).Children(2).Color ='red'
