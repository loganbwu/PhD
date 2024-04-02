# This script is to illustrate how a delay distribution works

library(tidyverse)
library(tidygraph)
library(GGally)

n_delays = 5

labels = c("S[0]", "S[L[1]]", "S[L[2]]", "S[L[K]]", "I[L[K]]")
edge_labels = c("Hypnozoite inoculation", "Advancement\nδ×n", "Advancement...\nδ×...", "Relapse\nƒ", "Recovery/treatment")
edge_linetype = c(1, 1, 2, 1, 1)

# labels = c("S[0]", paste0("S[L", seq_len(n_delays), "]"), paste0("I[L", n_delays, "]"))
# edge_labels = c("Hypnozoite inoculation", rep("Advancement\nδ×n", n_delays-1), "Relapse\nƒ", "Recovery\nr")
n_nodes = length(labels)

graph = create_ring(n_nodes, directed=T) %>%
  mutate(node_label=labels,
         color = c("steelblue", rep("gold", length(labels)-3), "orange", "tomato")) %>%
  activate("edges") %>%
  mutate(edge_label = edge_labels,
         edge_linetype = edge_linetype)

ggnet2(graph, mode='circle', 
       parse = TRUE,
       node.label="node_label", node.color="color", node.size=16,
       edge.label="edge_label", edge.lty = "edge_linetype",
       arrow.size=6, arrow.gap = 0.05)
ggsave("plots/delay_distribution_diagram.png", width=6, height=6)
