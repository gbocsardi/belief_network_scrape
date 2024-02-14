setwd('/Users/bocsar000/Documents/projects/scopus_scrape')

# Replace 'path/to/your/nodes.csv' and 'path/to/your/edges.csv' with the actual file paths
nodes <- read.csv("data/network/node_list.csv")
edges <- read.csv("data/network/edge_list.csv")

# Create a graph from the edge list
g <- igraph::graph_from_data_frame(d=edges, vertices=nodes, directed=FALSE)

# plotting and non isolated nodes
##### 


communities <- cluster_louvain(g)

# Step 2: Choose the Fruchterman-Reingold layout, applying it with the community structure in mind
layout <- layout_with_fr(g)

# Visualize the graph with the layout
plot(g, vertex.size=2, edge.arrow.size=.5, vertex.label=NA, # Set vertex size and edge arrow size
     vertex.color=membership(communities), # Color nodes based on their community
     main="Graph Visualization with Clusters")


# Find nodes with degree > 0 (not isolated)
non_isolated_nodes <- V(g)[degree(g) > 0]

# Create a subgraph with non-isolated nodes only
g_sub <- induced_subgraph(g, non_isolated_nodes)

# Now, plot the subgraph using your preferred layout
plot(g_sub, vertex.label=NA, vertex.size=2, layout=layout_with_fr(g_sub), main="Network without Isolated Nodes")


non_iso_communities <- cluster_louvain(g_sub)


#####




# Network Density
density <- igraph::edge_density(g)
cat("Network Density: ", density, "\n")

# Triad Census
triad_census <- igraph::triad_census(g)
cat("Triad Census:\n")
print(triad_census)
cat("first is empty triad, 3rd is dyad with isolated third, 11th is A<->B<->C, last is full graph\n")

# Degree Distribution
degree_distribution <- igraph::degree_distribution(g)
cat("Degree Distribution (first few values):\n")
print(head(degree_distribution)) # Showing only the first few values for brevity

# Small-worldness requires more steps for a full assessment, starting with these basics:
clustering_coefficient <- igraph::transitivity(g, type = "average")
average_path_length <- igraph::mean_distance(g, directed = FALSE)
cat("Clustering Coefficient:", clustering_coefficient, "\n")
cat("Average Path Length:", average_path_length, "\n")
# Note: For a complete small-worldness assessment, compare these to equivalent random graphs.

# Betweenness Centrality
betweenness_centrality <- igraph::betweenness(g, directed = FALSE)
cat("Betweenness Centrality (first few nodes):\n")
# Printing only the first few values for brevity, consider using sort() or other methods to highlight key nodes
print(head(sort(betweenness_centrality)))
