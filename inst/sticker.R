library(ggplot2)
library(emojifont)
library(scales)
library(hexSticker)

load.fontawesome()

# icon <- ggplot() +
#   geom_text(aes(x = c(1), y = c(1), label = fontawesome('fa-thermometer-half')),
#             family = "fontawesome-webfont",
#             size = 90) +
#   theme_void() + theme_transparent()
#
# s <- sticker(icon, package="",
#              s_x=1, s_y=1.15, s_width=1.8, s_height=2,
#              filename="man/figures/sticker.png",
#              h_fill = colorRampPalette(c("white", CTUtemplate::unibeRed()))(6)[3],
#              h_color = CTUtemplate::unibeRed(),
#              h_size = 2,
#              url = "kpitools",
#              u_size = 12,
#              u_x = 1,
#              u_y = 0.15
# )
# s

gg.gauge <- function(pos,breaks=c(0,33,66,100),determinent) {

  require(ggplot2)

  get.poly <- function(a,b,r1=0.5,r2=1.0) {
    th.start <- pi*(1-a/100)
    th.end   <- pi*(1-b/100)
    th       <- seq(th.start,th.end,length=100)
    x        <- c(r1*cos(th),rev(r2*cos(th)))
    y        <- c(r1*sin(th),rev(r2*sin(th)))
    return(data.frame(x,y))
  }

  ggplot()+
    geom_polygon(data=get.poly(breaks[1],breaks[2]),aes(x,y), fill = NA, col = 1, lwd = 1.5)+
    geom_polygon(data=get.poly(breaks[2],breaks[3]),aes(x,y), fill = NA, col = 1, lwd = 1.5)+
    geom_polygon(data=get.poly(breaks[3],breaks[4]),aes(x,y), fill = NA, col = 1, lwd = 1.5)+
    geom_polygon(data=get.poly(pos-1,pos+1,0.2),aes(x,y))+
    # geom_text(data=as.data.frame(breaks), size=5, fontface="bold", vjust=0,
    #           aes(x=0.8*cos(pi*(1-    breaks/100)),y=-0.1),label=c('Less','','',"More"))+
    annotate("text",x=0,y=0,label=determinent,vjust=0,size=8,fontface="bold")+
    coord_fixed()+
    theme_bw()+
    theme(axis.text=element_blank(),
          axis.title=element_blank(),
          axis.ticks=element_blank(),
          panel.grid=element_blank(),
          panel.border=element_blank(),
          legend.position = "none")
}

# gg.gauge <- function(pos, breaks = c(0, 33, 66, 100), determinent) {
#   require(ggplot2)
#   get.poly <- function(a, b, r1 = 0.5, r2 = 1.0) {
#     th.start <- pi * (1 - a / 100)
#     th.end   <- pi * (1 - b / 100)
#     th       <- seq(th.start, th.end, length = 1000)
#     x        <- r1 * cos(th)
#     xend     <- r2 * cos(th)
#     y        <- r1 * sin(th)
#     yend     <- r2 * sin(th)
#     data.frame(x, y, xend, yend)
#   }
#
#   ggplot() +
#     geom_segment(data = get.poly(breaks[1],breaks[4]),
#                  aes(x = x, y = y, xend = xend, yend = yend, color = xend)) +
#     scale_color_gradientn(colors = c("red", "gold", "green")) +
#     geom_segment(data = get.poly(pos - 1, pos + 1, 0.2), aes(x = x, y  =y, xend = xend, yend = yend)) +
#     geom_text(data=as.data.frame(breaks), size = 5, fontface = "bold", vjust = 0,
#               aes(x = 0.8 * cos(pi * (1 - breaks / 100)),  y = -0.1), label = c('Less', '', '', "More")) +
#     annotate("text", x  = 0, y = 0,label=determinent,vjust=0,size=8,fontface="bold")+
#     coord_fixed()+
#     theme_bw()+
#     theme(axis.text=element_blank(),
#           axis.title=element_blank(),
#           axis.ticks=element_blank(),
#           panel.grid=element_blank(),
#           panel.border=element_blank(),
#           legend.position = "none")
# }
g <- gg.gauge(pos = 10, determinent = "") + theme_void()

s <- sticker(g, package="",
             s_x=1, s_y=1.15, s_width=1.6, s_height=2,
             filename="man/figures/logo.png",
             h_fill = colorRampPalette(c("white", CTUtemplate::unibeRed()))(6)[3],
             h_color = CTUtemplate::unibeRed(),
             h_size = 2,
             url = "kpitools",
             u_size = 12,
             u_x = 1,
             u_y = 0.15
)
s
