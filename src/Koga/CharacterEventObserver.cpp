#include "Koga/CharacterEventObserver.h"

bool Koga::CharacterEventObserver::receiveEvent(CharacterEvent* event) {
  switch(event->field_0x00) {
    default:
      return false;
    case 0:
      return true;
    case 2:
      return func_800ea368(event);
    case 3:
      return func_800ea370(event);
    case 4:
      return func_800ea378(event);
    case 8:
      return func_800ea380(event);
    case 12:
      return func_800ea388(event);
    case 13:
      return func_800ea390(event);
    case 14:
      return func_800ea398(event);
    case 15:
      return func_800ea3a0(event);
    case 16:
      return func_800ea3a8(event);
    case 17:
      return func_800ea3d4(event);
    case 18:
      return func_800ea400(event);
    case 9:
      return func_800ea42c(event);
    case 10:
      return func_800ea434(event);
    case 11:
      return func_800ea43c(event);
    case 19:
      return func_800ea444(event);
    case 29:
      return func_800ea44c(event);
  }
}
