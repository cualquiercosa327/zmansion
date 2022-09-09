#include "EnemyStrategy.h"

EnemyStrategy::EnemyStrategy() {
  mpThought = nullptr;
  mUnknownInt0 = 0;
  mNextState = 0;
  mCurrentState = 0;
  mCurrentTimer = 0;
}

EnemyStrategy::~EnemyStrategy() {
  
}

void EnemyStrategy::func_800c22ac() {
  
}

void EnemyStrategy::update() {
  if (mNextState != 0xFFFF) {
      changeState();
  }
  
  executeBehavior();
  mCurrentTimer += 1;
}

void EnemyStrategy::executeBehavior() {
  
}

void EnemyStrategy::executeBehaviorInit() {
  
}

bool EnemyStrategy::func_800c2314() {
  return false;
}

void EnemyStrategy::func_800c231c() {
  
}

void EnemyStrategy::setNextState(unsigned short state) {
  mNextState = state;
}

void EnemyStrategy::changeState() {
  mCurrentState = mNextState;
  mNextState = -1;
  mCurrentTimer = 0;
  
  executeBehaviorInit();
}
