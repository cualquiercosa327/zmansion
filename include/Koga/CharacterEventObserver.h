#include "Observer.h"
#include "CharacterEvent.h"

namespace Koga {
  class CharacterEventObserver : public Observer<CharacterEvent, bool> {
      virtual bool func_800ea368(CharacterEvent* event); // 0x0C
      virtual bool func_800ea370(CharacterEvent* event); // 0x10
      virtual bool func_800ea378(CharacterEvent* event); // 0x14
      virtual bool func_800ea380(CharacterEvent* event); // 0x18
      virtual bool func_800ea388(CharacterEvent* event); // 0x1C
      virtual bool func_800ea390(CharacterEvent* event); // 0x20
      virtual bool func_800ea398(CharacterEvent* event); // 0x24
      virtual bool func_800ea3a0(CharacterEvent* event); // 0x28
      virtual bool func_800ea3a8(CharacterEvent* event); // 0x2C
      virtual bool func_800ea3d4(CharacterEvent* event); // 0x30
      virtual bool func_800ea400(CharacterEvent* event); // 0x34
      virtual bool func_800ea42c(CharacterEvent* event); // 0x38
      virtual bool func_800ea434(CharacterEvent* event); // 0x3C
      virtual bool func_800ea43c(CharacterEvent* event); // 0x40
      virtual bool func_800ea444(CharacterEvent* event); // 0x44
      virtual bool func_800ea44c(CharacterEvent* event); // 0x48

  public:
      bool receiveEvent(CharacterEvent* event); // 0x08
  };
}