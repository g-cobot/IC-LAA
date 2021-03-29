%Configurando a imagem
%Abra a imagem depois rode o seguinte comando
figura=gcf
%Arrumando a Legenda
%ligando a legenda
legend('Resultado experimental','Curva aproximada')
legend('Interpreter','latex')
legend('location','northeast')
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
figura.Children(2).XTick= 0:1:5
figura.Children(2).XLim= [0 5]
figura.Children(2).XLabel.String='Tempo\hspace{0.5em}[s]'
figura.Children(2).XLabel.Interpreter='latex'
%Arrumando o eixo Y
figura.Children(2).YGrid=1
figura.Children(2).YTick= linspace(0,0.2,5)
figura.Children(2).YLim= [0 0.2]
figura.Children(2).YLabel.String='$\theta_4$\hspace{0.5em}[rad]'
figura.Children(2).YLabel.Interpreter='latex'
figura.Children(2).Children(1).Color ='red'
figura.Children(2).Children(2).Color ='black'
