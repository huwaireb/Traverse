#ifndef GRAPH_HH
#define GRAPH_HH

#include <string>
#include <swift/bridging>
#include <unordered_map>
#include <vector>

class Graph {
  public:
    Graph();
    ~Graph();

    void addNode(const std::string &node);
    void addEdge(const std::string &from, const std::string &to, double weight);
    std::vector<std::string> shortestPath(const std::string &start,
                                          const std::string &end);

  private:
    struct Edge {
        std::string to;
        double weight;
    };
    std::unordered_map<std::string, std::vector<Edge>> adjList;
};

#endif // GRAPH_HH
