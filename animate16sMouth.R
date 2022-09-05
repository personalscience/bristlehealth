# animate16SMouth.R

library(gganimate)
if(!require("ggfittext")) install.packages("ggfittext")



load("mouth_microbes.rda")
ganim <- all_tm %>% filter(sample %in% 1:50) %>%
  group_by(sample) %>%
  ggplot(aes(xmin = x0, ymin = y0, xmax = x1, ymax = y1, mysample=sample)) +
  # add fill and borders for groups and subgroups
  geom_rect(aes(fill = color, size = primary_group),
            show.legend = FALSE, color = "black", alpha = .3) +
  # geom_text(color = "red", aes(x=0, y=0 ,
  #               label = sprintf("Sample = %s", factor(sample)))) +
  scale_fill_identity() +
  # set thicker lines for group borders
  scale_size(range = range(all_tm$primary_group)) +
  # add labels
  ggfittext::geom_fit_text(aes(label = genus), min.size = 1) +
  # options
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  #labs(title = "My Mouth Microbiome Through Time")+ #, subtitle = "{current_frame") +

  gganimate::transition_states(sample, state_length = .2, transition_length = .40) +
  labs(title = "My Mouth Microbiome Through Time",
       # subtitle = "Number of days: {filter(.data, my_tm == current_frame) %>% pull(sample) %>% .[[1]]}") +
       subtitle = "Day: {closest_state}") +
  theme_void() +
  gganimate::enter_fade() +
  gganimate::exit_fade() +
  ease_aes('quadratic-in-out')

gganimate::animate(plot=ganim, end_pause = 10, detail = 20, fps=12, duration = 60)
gganimate::anim_save("mouth16sAll.gif")
