#include "Graph.hh"
#include <algorithm>
#include <limits>
#include <queue>

Graph::Graph() {}
Graph::~Graph() {}

void Graph::addNode(const std::string &node) {
    if (adjList.find(node) == adjList.end()) {
        adjList[node] = std::vector<Edge>();
    }
}

void Graph::addEdge(const std::string &from, const std::string &to,
                    double weight) {
    addNode(from);
    addNode(to);
    adjList[from].push_back({to, weight});
    adjList[to].push_back({from, weight}); // Undirected graph
}

std::vector<std::string> Graph::shortestPath(const std::string &start,
                                             const std::string &end) {
    if (adjList.find(start) == adjList.end() ||
        adjList.find(end) == adjList.end()) {
        return {};
    }

    std::unordered_map<std::string, double> distances;
    std::unordered_map<std::string, std::string> previous;
    for (const auto &pair : adjList) {
        distances[pair.first] = std::numeric_limits<double>::infinity();
    }
    distances[start] = 0;

    using P = std::pair<double, std::string>;
    std::priority_queue<P, std::vector<P>, std::greater<P>> pq;
    pq.push({0, start});

    while (!pq.empty()) {
        auto [dist, current] = pq.top();
        pq.pop();

        if (current == end) {
            break;
        }

        if (dist > distances[current]) {
            continue;
        }

        for (const auto &edge : adjList[current]) {
            double newDist = dist + edge.weight;
            if (newDist < distances[edge.to]) {
                distances[edge.to] = newDist;
                previous[edge.to] = current;
                pq.push({newDist, edge.to});
            }
        }
    }

    if (distances[end] == std::numeric_limits<double>::infinity()) {
        return {};
    }

    std::vector<std::string> path;
    std::string current = end;
    while (current != start) {
        path.push_back(current);
        current = previous[current];
    }
    path.push_back(start);
    std::reverse(path.begin(), path.end());
    return path;
}
