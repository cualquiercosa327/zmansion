
namespace Koga {
  template<typename T, typename U>
  class Observer {
  public:
    virtual U receiveEvent(T event) = 0;
  };
}
