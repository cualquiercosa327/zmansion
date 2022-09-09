#include "JORReflexible.h"

class EnemyStrategy : public JORReflexible {
public:
    EnemyStrategy();
    virtual ~EnemyStrategy();
    
    virtual void func_800c22ac();
    virtual void update();
    virtual bool func_800c2314();
    virtual void func_800c231c();
    virtual void executeBehavior();
    virtual void executeBehaviorInit();
    
    void setNextState(unsigned short state);
    void changeState();
    
protected:
    void* mpThought;
    int mUnknownInt0;
    short mNextState;
    short mCurrentState;
    unsigned int mCurrentTimer;
};
