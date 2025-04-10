// automatically generated by the FlatBuffers compiler, do not modify


#ifndef FLATBUFFERS_GENERATED_SPEC_H_
#define FLATBUFFERS_GENERATED_SPEC_H_

#include "flatbuffers/flatbuffers.h"

// Ensure the included flatbuffers.h is the same version as when this file was
// generated, otherwise it may not be compatible.
static_assert(FLATBUFFERS_VERSION_MAJOR == 25 &&
              FLATBUFFERS_VERSION_MINOR == 1 &&
              FLATBUFFERS_VERSION_REVISION == 24,
             "Non-compatible flatbuffers version included");

struct Coordinates;
struct CoordinatesBuilder;

struct NodeAttributes;
struct NodeAttributesBuilder;

struct Node;
struct NodeBuilder;

struct EdgeAttributes;
struct EdgeAttributesBuilder;

struct Edge;
struct EdgeBuilder;

struct CampusMap;
struct CampusMapBuilder;

enum NodeType : int8_t {
  NodeType_Building = 0,
  NodeType_Room = 1,
  NodeType_Hallway = 2,
  NodeType_Entrance = 3,
  NodeType_Stairs = 4,
  NodeType_Elevator = 5,
  NodeType_CafeArea = 6,
  NodeType_StudySpace = 7,
  NodeType_OutdoorPath = 8,
  NodeType_MIN = NodeType_Building,
  NodeType_MAX = NodeType_OutdoorPath
};

inline const NodeType (&EnumValuesNodeType())[9] {
  static const NodeType values[] = {
    NodeType_Building,
    NodeType_Room,
    NodeType_Hallway,
    NodeType_Entrance,
    NodeType_Stairs,
    NodeType_Elevator,
    NodeType_CafeArea,
    NodeType_StudySpace,
    NodeType_OutdoorPath
  };
  return values;
}

inline const char * const *EnumNamesNodeType() {
  static const char * const names[10] = {
    "Building",
    "Room",
    "Hallway",
    "Entrance",
    "Stairs",
    "Elevator",
    "CafeArea",
    "StudySpace",
    "OutdoorPath",
    nullptr
  };
  return names;
}

inline const char *EnumNameNodeType(NodeType e) {
  if (::flatbuffers::IsOutRange(e, NodeType_Building, NodeType_OutdoorPath)) return "";
  const size_t index = static_cast<size_t>(e);
  return EnumNamesNodeType()[index];
}

struct Coordinates FLATBUFFERS_FINAL_CLASS : private ::flatbuffers::Table {
  typedef CoordinatesBuilder Builder;
  enum FlatBuffersVTableOffset FLATBUFFERS_VTABLE_UNDERLYING_TYPE {
    VT_X = 4,
    VT_Y = 6,
    VT_Z = 8
  };
  float x() const {
    return GetField<float>(VT_X, 0.0f);
  }
  float y() const {
    return GetField<float>(VT_Y, 0.0f);
  }
  float z() const {
    return GetField<float>(VT_Z, 0.0f);
  }
  bool Verify(::flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<float>(verifier, VT_X, 4) &&
           VerifyField<float>(verifier, VT_Y, 4) &&
           VerifyField<float>(verifier, VT_Z, 4) &&
           verifier.EndTable();
  }
};

struct CoordinatesBuilder {
  typedef Coordinates Table;
  ::flatbuffers::FlatBufferBuilder &fbb_;
  ::flatbuffers::uoffset_t start_;
  void add_x(float x) {
    fbb_.AddElement<float>(Coordinates::VT_X, x, 0.0f);
  }
  void add_y(float y) {
    fbb_.AddElement<float>(Coordinates::VT_Y, y, 0.0f);
  }
  void add_z(float z) {
    fbb_.AddElement<float>(Coordinates::VT_Z, z, 0.0f);
  }
  explicit CoordinatesBuilder(::flatbuffers::FlatBufferBuilder &_fbb)
        : fbb_(_fbb) {
    start_ = fbb_.StartTable();
  }
  ::flatbuffers::Offset<Coordinates> Finish() {
    const auto end = fbb_.EndTable(start_);
    auto o = ::flatbuffers::Offset<Coordinates>(end);
    return o;
  }
};

inline ::flatbuffers::Offset<Coordinates> CreateCoordinates(
    ::flatbuffers::FlatBufferBuilder &_fbb,
    float x = 0.0f,
    float y = 0.0f,
    float z = 0.0f) {
  CoordinatesBuilder builder_(_fbb);
  builder_.add_z(z);
  builder_.add_y(y);
  builder_.add_x(x);
  return builder_.Finish();
}

struct NodeAttributes FLATBUFFERS_FINAL_CLASS : private ::flatbuffers::Table {
  typedef NodeAttributesBuilder Builder;
  enum FlatBuffersVTableOffset FLATBUFFERS_VTABLE_UNDERLYING_TYPE {
    VT_WHEELCHAIR_ACCESSIBLE = 4,
    VT_CAPACITY = 6,
    VT_INDOOR = 8,
    VT_RESTRICTED_ACCESS = 10,
    VT_AR_ANCHOR_ID = 12
  };
  bool wheelchair_accessible() const {
    return GetField<uint8_t>(VT_WHEELCHAIR_ACCESSIBLE, 0) != 0;
  }
  int32_t capacity() const {
    return GetField<int32_t>(VT_CAPACITY, 0);
  }
  bool indoor() const {
    return GetField<uint8_t>(VT_INDOOR, 1) != 0;
  }
  bool restricted_access() const {
    return GetField<uint8_t>(VT_RESTRICTED_ACCESS, 0) != 0;
  }
  const ::flatbuffers::String *ar_anchor_id() const {
    return GetPointer<const ::flatbuffers::String *>(VT_AR_ANCHOR_ID);
  }
  bool Verify(::flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<uint8_t>(verifier, VT_WHEELCHAIR_ACCESSIBLE, 1) &&
           VerifyField<int32_t>(verifier, VT_CAPACITY, 4) &&
           VerifyField<uint8_t>(verifier, VT_INDOOR, 1) &&
           VerifyField<uint8_t>(verifier, VT_RESTRICTED_ACCESS, 1) &&
           VerifyOffset(verifier, VT_AR_ANCHOR_ID) &&
           verifier.VerifyString(ar_anchor_id()) &&
           verifier.EndTable();
  }
};

struct NodeAttributesBuilder {
  typedef NodeAttributes Table;
  ::flatbuffers::FlatBufferBuilder &fbb_;
  ::flatbuffers::uoffset_t start_;
  void add_wheelchair_accessible(bool wheelchair_accessible) {
    fbb_.AddElement<uint8_t>(NodeAttributes::VT_WHEELCHAIR_ACCESSIBLE, static_cast<uint8_t>(wheelchair_accessible), 0);
  }
  void add_capacity(int32_t capacity) {
    fbb_.AddElement<int32_t>(NodeAttributes::VT_CAPACITY, capacity, 0);
  }
  void add_indoor(bool indoor) {
    fbb_.AddElement<uint8_t>(NodeAttributes::VT_INDOOR, static_cast<uint8_t>(indoor), 1);
  }
  void add_restricted_access(bool restricted_access) {
    fbb_.AddElement<uint8_t>(NodeAttributes::VT_RESTRICTED_ACCESS, static_cast<uint8_t>(restricted_access), 0);
  }
  void add_ar_anchor_id(::flatbuffers::Offset<::flatbuffers::String> ar_anchor_id) {
    fbb_.AddOffset(NodeAttributes::VT_AR_ANCHOR_ID, ar_anchor_id);
  }
  explicit NodeAttributesBuilder(::flatbuffers::FlatBufferBuilder &_fbb)
        : fbb_(_fbb) {
    start_ = fbb_.StartTable();
  }
  ::flatbuffers::Offset<NodeAttributes> Finish() {
    const auto end = fbb_.EndTable(start_);
    auto o = ::flatbuffers::Offset<NodeAttributes>(end);
    return o;
  }
};

inline ::flatbuffers::Offset<NodeAttributes> CreateNodeAttributes(
    ::flatbuffers::FlatBufferBuilder &_fbb,
    bool wheelchair_accessible = false,
    int32_t capacity = 0,
    bool indoor = true,
    bool restricted_access = false,
    ::flatbuffers::Offset<::flatbuffers::String> ar_anchor_id = 0) {
  NodeAttributesBuilder builder_(_fbb);
  builder_.add_ar_anchor_id(ar_anchor_id);
  builder_.add_capacity(capacity);
  builder_.add_restricted_access(restricted_access);
  builder_.add_indoor(indoor);
  builder_.add_wheelchair_accessible(wheelchair_accessible);
  return builder_.Finish();
}

inline ::flatbuffers::Offset<NodeAttributes> CreateNodeAttributesDirect(
    ::flatbuffers::FlatBufferBuilder &_fbb,
    bool wheelchair_accessible = false,
    int32_t capacity = 0,
    bool indoor = true,
    bool restricted_access = false,
    const char *ar_anchor_id = nullptr) {
  auto ar_anchor_id__ = ar_anchor_id ? _fbb.CreateString(ar_anchor_id) : 0;
  return CreateNodeAttributes(
      _fbb,
      wheelchair_accessible,
      capacity,
      indoor,
      restricted_access,
      ar_anchor_id__);
}

struct Node FLATBUFFERS_FINAL_CLASS : private ::flatbuffers::Table {
  typedef NodeBuilder Builder;
  enum FlatBuffersVTableOffset FLATBUFFERS_VTABLE_UNDERLYING_TYPE {
    VT_ID = 4,
    VT_NAME = 6,
    VT_TYPE = 8,
    VT_COORDINATES = 10,
    VT_FLOOR = 12,
    VT_ATTRIBUTES = 14
  };
  const ::flatbuffers::String *id() const {
    return GetPointer<const ::flatbuffers::String *>(VT_ID);
  }
  bool KeyCompareLessThan(const Node * const o) const {
    return *id() < *o->id();
  }
  int KeyCompareWithValue(const char *_id) const {
    return strcmp(id()->c_str(), _id);
  }
  template<typename StringType>
  int KeyCompareWithValue(const StringType& _id) const {
    if (id()->c_str() < _id) return -1;
    if (_id < id()->c_str()) return 1;
    return 0;
  }
  const ::flatbuffers::String *name() const {
    return GetPointer<const ::flatbuffers::String *>(VT_NAME);
  }
  NodeType type() const {
    return static_cast<NodeType>(GetField<int8_t>(VT_TYPE, 0));
  }
  const Coordinates *coordinates() const {
    return GetPointer<const Coordinates *>(VT_COORDINATES);
  }
  int32_t floor() const {
    return GetField<int32_t>(VT_FLOOR, 0);
  }
  const NodeAttributes *attributes() const {
    return GetPointer<const NodeAttributes *>(VT_ATTRIBUTES);
  }
  bool Verify(::flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyOffsetRequired(verifier, VT_ID) &&
           verifier.VerifyString(id()) &&
           VerifyOffset(verifier, VT_NAME) &&
           verifier.VerifyString(name()) &&
           VerifyField<int8_t>(verifier, VT_TYPE, 1) &&
           VerifyOffset(verifier, VT_COORDINATES) &&
           verifier.VerifyTable(coordinates()) &&
           VerifyField<int32_t>(verifier, VT_FLOOR, 4) &&
           VerifyOffset(verifier, VT_ATTRIBUTES) &&
           verifier.VerifyTable(attributes()) &&
           verifier.EndTable();
  }
};

struct NodeBuilder {
  typedef Node Table;
  ::flatbuffers::FlatBufferBuilder &fbb_;
  ::flatbuffers::uoffset_t start_;
  void add_id(::flatbuffers::Offset<::flatbuffers::String> id) {
    fbb_.AddOffset(Node::VT_ID, id);
  }
  void add_name(::flatbuffers::Offset<::flatbuffers::String> name) {
    fbb_.AddOffset(Node::VT_NAME, name);
  }
  void add_type(NodeType type) {
    fbb_.AddElement<int8_t>(Node::VT_TYPE, static_cast<int8_t>(type), 0);
  }
  void add_coordinates(::flatbuffers::Offset<Coordinates> coordinates) {
    fbb_.AddOffset(Node::VT_COORDINATES, coordinates);
  }
  void add_floor(int32_t floor) {
    fbb_.AddElement<int32_t>(Node::VT_FLOOR, floor, 0);
  }
  void add_attributes(::flatbuffers::Offset<NodeAttributes> attributes) {
    fbb_.AddOffset(Node::VT_ATTRIBUTES, attributes);
  }
  explicit NodeBuilder(::flatbuffers::FlatBufferBuilder &_fbb)
        : fbb_(_fbb) {
    start_ = fbb_.StartTable();
  }
  ::flatbuffers::Offset<Node> Finish() {
    const auto end = fbb_.EndTable(start_);
    auto o = ::flatbuffers::Offset<Node>(end);
    fbb_.Required(o, Node::VT_ID);
    return o;
  }
};

inline ::flatbuffers::Offset<Node> CreateNode(
    ::flatbuffers::FlatBufferBuilder &_fbb,
    ::flatbuffers::Offset<::flatbuffers::String> id = 0,
    ::flatbuffers::Offset<::flatbuffers::String> name = 0,
    NodeType type = NodeType_Building,
    ::flatbuffers::Offset<Coordinates> coordinates = 0,
    int32_t floor = 0,
    ::flatbuffers::Offset<NodeAttributes> attributes = 0) {
  NodeBuilder builder_(_fbb);
  builder_.add_attributes(attributes);
  builder_.add_floor(floor);
  builder_.add_coordinates(coordinates);
  builder_.add_name(name);
  builder_.add_id(id);
  builder_.add_type(type);
  return builder_.Finish();
}

inline ::flatbuffers::Offset<Node> CreateNodeDirect(
    ::flatbuffers::FlatBufferBuilder &_fbb,
    const char *id = nullptr,
    const char *name = nullptr,
    NodeType type = NodeType_Building,
    ::flatbuffers::Offset<Coordinates> coordinates = 0,
    int32_t floor = 0,
    ::flatbuffers::Offset<NodeAttributes> attributes = 0) {
  auto id__ = id ? _fbb.CreateString(id) : 0;
  auto name__ = name ? _fbb.CreateString(name) : 0;
  return CreateNode(
      _fbb,
      id__,
      name__,
      type,
      coordinates,
      floor,
      attributes);
}

struct EdgeAttributes FLATBUFFERS_FINAL_CLASS : private ::flatbuffers::Table {
  typedef EdgeAttributesBuilder Builder;
  enum FlatBuffersVTableOffset FLATBUFFERS_VTABLE_UNDERLYING_TYPE {
    VT_INDOOR = 4,
    VT_STAIRS_COUNT = 6,
    VT_CROWDED_DURING_PEAKS = 8,
    VT_WHEELCHAIR_ACCESSIBLE = 10,
    VT_COVERED = 12
  };
  bool indoor() const {
    return GetField<uint8_t>(VT_INDOOR, 1) != 0;
  }
  int32_t stairs_count() const {
    return GetField<int32_t>(VT_STAIRS_COUNT, 0);
  }
  bool crowded_during_peaks() const {
    return GetField<uint8_t>(VT_CROWDED_DURING_PEAKS, 0) != 0;
  }
  bool wheelchair_accessible() const {
    return GetField<uint8_t>(VT_WHEELCHAIR_ACCESSIBLE, 1) != 0;
  }
  bool covered() const {
    return GetField<uint8_t>(VT_COVERED, 1) != 0;
  }
  bool Verify(::flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<uint8_t>(verifier, VT_INDOOR, 1) &&
           VerifyField<int32_t>(verifier, VT_STAIRS_COUNT, 4) &&
           VerifyField<uint8_t>(verifier, VT_CROWDED_DURING_PEAKS, 1) &&
           VerifyField<uint8_t>(verifier, VT_WHEELCHAIR_ACCESSIBLE, 1) &&
           VerifyField<uint8_t>(verifier, VT_COVERED, 1) &&
           verifier.EndTable();
  }
};

struct EdgeAttributesBuilder {
  typedef EdgeAttributes Table;
  ::flatbuffers::FlatBufferBuilder &fbb_;
  ::flatbuffers::uoffset_t start_;
  void add_indoor(bool indoor) {
    fbb_.AddElement<uint8_t>(EdgeAttributes::VT_INDOOR, static_cast<uint8_t>(indoor), 1);
  }
  void add_stairs_count(int32_t stairs_count) {
    fbb_.AddElement<int32_t>(EdgeAttributes::VT_STAIRS_COUNT, stairs_count, 0);
  }
  void add_crowded_during_peaks(bool crowded_during_peaks) {
    fbb_.AddElement<uint8_t>(EdgeAttributes::VT_CROWDED_DURING_PEAKS, static_cast<uint8_t>(crowded_during_peaks), 0);
  }
  void add_wheelchair_accessible(bool wheelchair_accessible) {
    fbb_.AddElement<uint8_t>(EdgeAttributes::VT_WHEELCHAIR_ACCESSIBLE, static_cast<uint8_t>(wheelchair_accessible), 1);
  }
  void add_covered(bool covered) {
    fbb_.AddElement<uint8_t>(EdgeAttributes::VT_COVERED, static_cast<uint8_t>(covered), 1);
  }
  explicit EdgeAttributesBuilder(::flatbuffers::FlatBufferBuilder &_fbb)
        : fbb_(_fbb) {
    start_ = fbb_.StartTable();
  }
  ::flatbuffers::Offset<EdgeAttributes> Finish() {
    const auto end = fbb_.EndTable(start_);
    auto o = ::flatbuffers::Offset<EdgeAttributes>(end);
    return o;
  }
};

inline ::flatbuffers::Offset<EdgeAttributes> CreateEdgeAttributes(
    ::flatbuffers::FlatBufferBuilder &_fbb,
    bool indoor = true,
    int32_t stairs_count = 0,
    bool crowded_during_peaks = false,
    bool wheelchair_accessible = true,
    bool covered = true) {
  EdgeAttributesBuilder builder_(_fbb);
  builder_.add_stairs_count(stairs_count);
  builder_.add_covered(covered);
  builder_.add_wheelchair_accessible(wheelchair_accessible);
  builder_.add_crowded_during_peaks(crowded_during_peaks);
  builder_.add_indoor(indoor);
  return builder_.Finish();
}

struct Edge FLATBUFFERS_FINAL_CLASS : private ::flatbuffers::Table {
  typedef EdgeBuilder Builder;
  enum FlatBuffersVTableOffset FLATBUFFERS_VTABLE_UNDERLYING_TYPE {
    VT_SOURCE_ID = 4,
    VT_TARGET_ID = 6,
    VT_DISTANCE = 8,
    VT_AVG_TIME = 10,
    VT_ATTRIBUTES = 12
  };
  const ::flatbuffers::String *source_id() const {
    return GetPointer<const ::flatbuffers::String *>(VT_SOURCE_ID);
  }
  const ::flatbuffers::String *target_id() const {
    return GetPointer<const ::flatbuffers::String *>(VT_TARGET_ID);
  }
  float distance() const {
    return GetField<float>(VT_DISTANCE, 0.0f);
  }
  int32_t avg_time() const {
    return GetField<int32_t>(VT_AVG_TIME, 0);
  }
  const EdgeAttributes *attributes() const {
    return GetPointer<const EdgeAttributes *>(VT_ATTRIBUTES);
  }
  bool Verify(::flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyOffset(verifier, VT_SOURCE_ID) &&
           verifier.VerifyString(source_id()) &&
           VerifyOffset(verifier, VT_TARGET_ID) &&
           verifier.VerifyString(target_id()) &&
           VerifyField<float>(verifier, VT_DISTANCE, 4) &&
           VerifyField<int32_t>(verifier, VT_AVG_TIME, 4) &&
           VerifyOffset(verifier, VT_ATTRIBUTES) &&
           verifier.VerifyTable(attributes()) &&
           verifier.EndTable();
  }
};

struct EdgeBuilder {
  typedef Edge Table;
  ::flatbuffers::FlatBufferBuilder &fbb_;
  ::flatbuffers::uoffset_t start_;
  void add_source_id(::flatbuffers::Offset<::flatbuffers::String> source_id) {
    fbb_.AddOffset(Edge::VT_SOURCE_ID, source_id);
  }
  void add_target_id(::flatbuffers::Offset<::flatbuffers::String> target_id) {
    fbb_.AddOffset(Edge::VT_TARGET_ID, target_id);
  }
  void add_distance(float distance) {
    fbb_.AddElement<float>(Edge::VT_DISTANCE, distance, 0.0f);
  }
  void add_avg_time(int32_t avg_time) {
    fbb_.AddElement<int32_t>(Edge::VT_AVG_TIME, avg_time, 0);
  }
  void add_attributes(::flatbuffers::Offset<EdgeAttributes> attributes) {
    fbb_.AddOffset(Edge::VT_ATTRIBUTES, attributes);
  }
  explicit EdgeBuilder(::flatbuffers::FlatBufferBuilder &_fbb)
        : fbb_(_fbb) {
    start_ = fbb_.StartTable();
  }
  ::flatbuffers::Offset<Edge> Finish() {
    const auto end = fbb_.EndTable(start_);
    auto o = ::flatbuffers::Offset<Edge>(end);
    return o;
  }
};

inline ::flatbuffers::Offset<Edge> CreateEdge(
    ::flatbuffers::FlatBufferBuilder &_fbb,
    ::flatbuffers::Offset<::flatbuffers::String> source_id = 0,
    ::flatbuffers::Offset<::flatbuffers::String> target_id = 0,
    float distance = 0.0f,
    int32_t avg_time = 0,
    ::flatbuffers::Offset<EdgeAttributes> attributes = 0) {
  EdgeBuilder builder_(_fbb);
  builder_.add_attributes(attributes);
  builder_.add_avg_time(avg_time);
  builder_.add_distance(distance);
  builder_.add_target_id(target_id);
  builder_.add_source_id(source_id);
  return builder_.Finish();
}

inline ::flatbuffers::Offset<Edge> CreateEdgeDirect(
    ::flatbuffers::FlatBufferBuilder &_fbb,
    const char *source_id = nullptr,
    const char *target_id = nullptr,
    float distance = 0.0f,
    int32_t avg_time = 0,
    ::flatbuffers::Offset<EdgeAttributes> attributes = 0) {
  auto source_id__ = source_id ? _fbb.CreateString(source_id) : 0;
  auto target_id__ = target_id ? _fbb.CreateString(target_id) : 0;
  return CreateEdge(
      _fbb,
      source_id__,
      target_id__,
      distance,
      avg_time,
      attributes);
}

struct CampusMap FLATBUFFERS_FINAL_CLASS : private ::flatbuffers::Table {
  typedef CampusMapBuilder Builder;
  enum FlatBuffersVTableOffset FLATBUFFERS_VTABLE_UNDERLYING_TYPE {
    VT_NAME = 4,
    VT_NODES = 6,
    VT_EDGES = 8,
    VT_VERSION = 10
  };
  const ::flatbuffers::String *name() const {
    return GetPointer<const ::flatbuffers::String *>(VT_NAME);
  }
  const ::flatbuffers::Vector<::flatbuffers::Offset<Node>> *nodes() const {
    return GetPointer<const ::flatbuffers::Vector<::flatbuffers::Offset<Node>> *>(VT_NODES);
  }
  const ::flatbuffers::Vector<::flatbuffers::Offset<Edge>> *edges() const {
    return GetPointer<const ::flatbuffers::Vector<::flatbuffers::Offset<Edge>> *>(VT_EDGES);
  }
  const ::flatbuffers::String *version() const {
    return GetPointer<const ::flatbuffers::String *>(VT_VERSION);
  }
  bool Verify(::flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyOffset(verifier, VT_NAME) &&
           verifier.VerifyString(name()) &&
           VerifyOffset(verifier, VT_NODES) &&
           verifier.VerifyVector(nodes()) &&
           verifier.VerifyVectorOfTables(nodes()) &&
           VerifyOffset(verifier, VT_EDGES) &&
           verifier.VerifyVector(edges()) &&
           verifier.VerifyVectorOfTables(edges()) &&
           VerifyOffset(verifier, VT_VERSION) &&
           verifier.VerifyString(version()) &&
           verifier.EndTable();
  }
};

struct CampusMapBuilder {
  typedef CampusMap Table;
  ::flatbuffers::FlatBufferBuilder &fbb_;
  ::flatbuffers::uoffset_t start_;
  void add_name(::flatbuffers::Offset<::flatbuffers::String> name) {
    fbb_.AddOffset(CampusMap::VT_NAME, name);
  }
  void add_nodes(::flatbuffers::Offset<::flatbuffers::Vector<::flatbuffers::Offset<Node>>> nodes) {
    fbb_.AddOffset(CampusMap::VT_NODES, nodes);
  }
  void add_edges(::flatbuffers::Offset<::flatbuffers::Vector<::flatbuffers::Offset<Edge>>> edges) {
    fbb_.AddOffset(CampusMap::VT_EDGES, edges);
  }
  void add_version(::flatbuffers::Offset<::flatbuffers::String> version) {
    fbb_.AddOffset(CampusMap::VT_VERSION, version);
  }
  explicit CampusMapBuilder(::flatbuffers::FlatBufferBuilder &_fbb)
        : fbb_(_fbb) {
    start_ = fbb_.StartTable();
  }
  ::flatbuffers::Offset<CampusMap> Finish() {
    const auto end = fbb_.EndTable(start_);
    auto o = ::flatbuffers::Offset<CampusMap>(end);
    return o;
  }
};

inline ::flatbuffers::Offset<CampusMap> CreateCampusMap(
    ::flatbuffers::FlatBufferBuilder &_fbb,
    ::flatbuffers::Offset<::flatbuffers::String> name = 0,
    ::flatbuffers::Offset<::flatbuffers::Vector<::flatbuffers::Offset<Node>>> nodes = 0,
    ::flatbuffers::Offset<::flatbuffers::Vector<::flatbuffers::Offset<Edge>>> edges = 0,
    ::flatbuffers::Offset<::flatbuffers::String> version = 0) {
  CampusMapBuilder builder_(_fbb);
  builder_.add_version(version);
  builder_.add_edges(edges);
  builder_.add_nodes(nodes);
  builder_.add_name(name);
  return builder_.Finish();
}

inline ::flatbuffers::Offset<CampusMap> CreateCampusMapDirect(
    ::flatbuffers::FlatBufferBuilder &_fbb,
    const char *name = nullptr,
    std::vector<::flatbuffers::Offset<Node>> *nodes = nullptr,
    const std::vector<::flatbuffers::Offset<Edge>> *edges = nullptr,
    const char *version = nullptr) {
  auto name__ = name ? _fbb.CreateString(name) : 0;
  auto nodes__ = nodes ? _fbb.CreateVectorOfSortedTables<Node>(nodes) : 0;
  auto edges__ = edges ? _fbb.CreateVector<::flatbuffers::Offset<Edge>>(*edges) : 0;
  auto version__ = version ? _fbb.CreateString(version) : 0;
  return CreateCampusMap(
      _fbb,
      name__,
      nodes__,
      edges__,
      version__);
}

inline const CampusMap *GetCampusMap(const void *buf) {
  return ::flatbuffers::GetRoot<CampusMap>(buf);
}

inline const CampusMap *GetSizePrefixedCampusMap(const void *buf) {
  return ::flatbuffers::GetSizePrefixedRoot<CampusMap>(buf);
}

inline bool VerifyCampusMapBuffer(
    ::flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<CampusMap>(nullptr);
}

inline bool VerifySizePrefixedCampusMapBuffer(
    ::flatbuffers::Verifier &verifier) {
  return verifier.VerifySizePrefixedBuffer<CampusMap>(nullptr);
}

inline void FinishCampusMapBuffer(
    ::flatbuffers::FlatBufferBuilder &fbb,
    ::flatbuffers::Offset<CampusMap> root) {
  fbb.Finish(root);
}

inline void FinishSizePrefixedCampusMapBuffer(
    ::flatbuffers::FlatBufferBuilder &fbb,
    ::flatbuffers::Offset<CampusMap> root) {
  fbb.FinishSizePrefixed(root);
}

#endif  // FLATBUFFERS_GENERATED_SPEC_H_
