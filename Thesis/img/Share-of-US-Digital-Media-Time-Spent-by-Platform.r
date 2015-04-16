Desktop <- c(55, 53, 51, 50, 49, 48, 48, 50, 50, 49, 47, 45, 45, 44, 43, 40 )
Mobile <- c(45, 47, 49, 50, 51, 52, 52, 50, 50, 51, 53, 55, 55, 56, 57, 60 )
Mobile_App <-c(38, 40, 41, 43, 42, 43, 44, 42, 41, 42, 44, 46, 46, 47, 48, 51 )


g_range <- range(35, Desktop, Mobile, Mobile_App)

dev.new(width=8, height=4)
plot(Desktop, type="o", col="blue", ylim=g_range, axes=FALSE, ann=FALSE)

axis(1, at=1:16, lab=c("Feb-2013","Mär-2013","Apr-2013","Mai-2013","Jun-2013","Jul-2013","Aug-2013","Sep-2013","Okt-2013","Nov-2013","Dez-2013","Jan-2014","Feb-2014","Mär-2014","Apr-2014","Mai-2014"))

axis(2, las=1, tcl=-0.5)

box()

lines(Mobile, type="o", pch=22, lty=1, col="red")
lines(Mobile_App, type="o", pch=22, lty=2, col="orange")


legend(1, g_range[2], c("Desktop","Mobile", "Mobile App"), cex=0.8, col=c("blue","red", "orange"), pch=21:22, lty=1:2);


