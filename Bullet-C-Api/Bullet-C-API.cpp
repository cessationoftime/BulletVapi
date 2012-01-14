/*
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2003-2006 Erwin Coumans  http://continuousphysics.com/Bullet/

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.
Permission is granted to anyone to use this software for any purpose, 
including commercial applications, and to alter it and redistribute it freely, 
subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
*/

/*
	Draft high-level generic physics C-API. For low-level access, use the physics SDK native API's.
	Work in progress, functionality will be added on demand.

	If possible, use the richer Bullet C++ API, by including <src/btBulletDynamicsCommon.h>
*/

#include "Bullet-C-Api.h"
#include "btBulletDynamicsCommon.h"
#include "LinearMath/btAlignedAllocator.h"



#include "LinearMath/btVector3.h"
#include "LinearMath/btScalar.h"	
#include "LinearMath/btMatrix3x3.h"
#include "LinearMath/btTransform.h"
#include "BulletCollision/NarrowPhaseCollision/btVoronoiSimplexSolver.h"
#include "BulletCollision/CollisionShapes/btTriangleShape.h"

#include "BulletCollision/NarrowPhaseCollision/btGjkPairDetector.h"
#include "BulletCollision/NarrowPhaseCollision/btPointCollector.h"
#include "BulletCollision/NarrowPhaseCollision/btVoronoiSimplexSolver.h"
#include "BulletCollision/NarrowPhaseCollision/btSubSimplexConvexCast.h"
#include "BulletCollision/NarrowPhaseCollision/btGjkEpaPenetrationDepthSolver.h"
#include "BulletCollision/NarrowPhaseCollision/btGjkEpa2.h"
#include "BulletCollision/CollisionShapes/btMinkowskiSumShape.h"
#include "BulletCollision/NarrowPhaseCollision/btDiscreteCollisionDetectorInterface.h"
#include "BulletCollision/NarrowPhaseCollision/btSimplexSolverInterface.h"
#include "BulletCollision/NarrowPhaseCollision/btMinkowskiPenetrationDepthSolver.h"

#define CAST_ASSERT(nameIN,typeOUT,nameOUT) typeOUT nameOUT = reinterpret_cast< typeOUT >( nameIN ); btAssert( nameOut )

/*
	Create and Delete a Physics SDK	
*/

struct	btPhysicsSdk
{

//	btDispatcher*				m_dispatcher;
//	btOverlappingPairCache*		m_pairCache;
//	btConstraintSolver*			m_constraintSolver

	btVector3	m_worldAabbMin;
	btVector3	m_worldAabbMax;


	//todo: version, hardware/optimization settings etc?
	btPhysicsSdk()
		:m_worldAabbMin(-1000,-1000,-1000),
		m_worldAabbMax(1000,1000,1000)
	{

	}

	
};

/*
Vector accessor and constructor functions, couldn't find a good way to get vala to work without them since I cant seem to create a new type that has an index on it.
*/


PlVector3* pl_vector3_new()
{

	PlVector3* mem = (PlVector3*)(btAlignedAlloc(3 * sizeof(PlReal),16));
	return mem;
}
PlVector3* pl_vector3_new_xyz(PlReal x, PlReal y, PlReal z)
{

	PlVector3* mem = (PlVector3*)(btAlignedAlloc(3 * sizeof(PlReal),16));
	mem[0] = x;
	mem[1] = y;
	mem[2] = z;
	return mem;
}

PlReal pl_vector3_get_x(PlVector3* v) {
	return v[0];
}
PlReal pl_vector3_get_y(PlVector3* v) {
	return v[1];
}
PlReal pl_vector3_get_z(PlVector3* v) {
	return v[2];
}
void pl_vector3_free(PlVector3* v) {
	btAlignedFree(v);
}

PlQuaternion* pl_quaternion_new()
{
	PlQuaternion* mem = (PlQuaternion*)(btAlignedAlloc(4 * sizeof(PlReal),16));
	return (PlQuaternion*)mem;
}
PlQuaternion* pl_quaternion_new_xyzw(PlReal x, PlReal y, PlReal z, PlReal w)
{
	PlQuaternion* mem = (PlQuaternion*)(btAlignedAlloc(4 * sizeof(PlReal),16));
	mem[0] = x;
	mem[1] = y;
	mem[2] = z;
	mem[3] = w;
	return (PlQuaternion*)mem;
}

PlReal pl_quaternion_get_x(PlQuaternion* v) {
	return v[0];
}
PlReal pl_quaternion_get_y(PlQuaternion* v) {
	return v[1];
}
PlReal pl_quaternion_get_z(PlQuaternion* v) {
	return v[2];
}
PlReal pl_quaternion_get_w(PlQuaternion* v) {
	return v[3];
}
void pl_quaternion_free(PlQuaternion* v) {
	btAlignedFree(v);
}


PlPhysicsSdk*	pl_physicssdk_new()
{
	void* mem = btAlignedAlloc(sizeof(btPhysicsSdk),16);
	return (PlPhysicsSdk*)new (mem)btPhysicsSdk;
}

void		pl_physicssdk_free(PlPhysicsSdk*	physicsSdk)
{
	btPhysicsSdk* phys = reinterpret_cast<btPhysicsSdk*>(physicsSdk);
	btAlignedFree(phys);	
}


/* Dynamics World */
PlDynamicsWorld* pl_dynamicsworld_new(PlPhysicsSdk* physicsSdk)
{
	btPhysicsSdk* phys = reinterpret_cast<btPhysicsSdk*>(physicsSdk);
	void* mem = btAlignedAlloc(sizeof(btDefaultCollisionConfiguration),16);
	btDefaultCollisionConfiguration* collisionConfiguration = new (mem)btDefaultCollisionConfiguration();
	mem = btAlignedAlloc(sizeof(btCollisionDispatcher),16);
	btDispatcher*				dispatcher = new (mem)btCollisionDispatcher(collisionConfiguration);
	mem = btAlignedAlloc(sizeof(btAxisSweep3),16);
	btBroadphaseInterface*		pairCache = new (mem)btAxisSweep3(phys->m_worldAabbMin,phys->m_worldAabbMax);
	mem = btAlignedAlloc(sizeof(btSequentialImpulseConstraintSolver),16);
	btConstraintSolver*			constraintSolver = new(mem) btSequentialImpulseConstraintSolver();

	mem = btAlignedAlloc(sizeof(btDiscreteDynamicsWorld),16);
	return (PlDynamicsWorld*) new (mem)btDiscreteDynamicsWorld(dispatcher,pairCache,constraintSolver,collisionConfiguration);
}
void           pl_dynamicsworld_free(PlDynamicsWorld* world)
{
	//todo: also clean up the other allocations, axisSweep, pairCache,dispatcher,constraintSolver,collisionConfiguration
	btDynamicsWorld* dynamicsWorld = reinterpret_cast< btDynamicsWorld* >(world);
	btAlignedFree(dynamicsWorld);
}

void pl_dynamicsworld_StepSimulation(PlDynamicsWorld* world,	PlReal	timeStep)
{
	CAST_ASSERT(world,btDynamicsWorld*,dynamicsWorld);

	dynamicsWorld->stepSimulation(timeStep);
}

void pl_dynamicsworld_AddRigidBody(PlDynamicsWorld* world, PlRigidBody* object)
{
	CAST_ASSERT(world,btDynamicsWorld*,dynamicsWorld);
	CAST_ASSERT(object,btRigidBody*,body);

	dynamicsWorld->addRigidBody(body);
}

void pl_dynamicsworld_RemoveRigidBody(PlDynamicsWorld* world, PlRigidBody* object)
{
	CAST_ASSERT(world,btDynamicsWorld*,dynamicsWorld);
	CAST_ASSERT(object,btRigidBody*,body);


	dynamicsWorld->removeRigidBody(body);
}

/* Rigid Body  */

PlRigidBody* pl_rigidbody_new(void* user_data,  float mass, PlCollisionShape* cshape )
{
	btTransform trans;
	trans.setIdentity();
	btVector3 localInertia(0,0,0);
	CAST_ASSERT(cshape,btCollisionShape*,shape);

	if (mass)
	{
		shape->calculateLocalInertia(mass,localInertia);
	}
	void* mem = btAlignedAlloc(sizeof(btRigidBody),16);
	btRigidBody::btRigidBodyConstructionInfo rbci(mass, 0,shape,localInertia);
	btRigidBody* body = new (mem)btRigidBody(rbci);
	body->setWorldTransform(trans);
	body->setUserPointer(user_data);
	return (PlRigidBody*) body;
}

void pl_rigidbody_free(PlRigidBody* cbody)
{
	CAST_ASSERT(cbody,btRigidBody*,body);
	btAlignedFree(body);
}


/* Collision Shape definition */

PlSphereShape* pl_sphereshape_new(PlReal radius)
{
	void* mem = btAlignedAlloc(sizeof(btSphereShape),16);
	return (PlSphereShape*) new (mem)btSphereShape(radius);
	
}
	
PlBoxShape* pl_boxshape_new(PlReal x, PlReal y, PlReal z)
{
	void* mem = btAlignedAlloc(sizeof(btBoxShape),16);
	return (PlBoxShape*) new (mem)btBoxShape(btVector3(x,y,z));
}

PlCapsuleShape* pl_capsuleshape_new(PlReal radius, PlReal height)
{
	//capsule is convex hull of 2 spheres, so use btMultiSphereShape
	
	const int numSpheres = 2;
	btVector3 positions[numSpheres] = {btVector3(0,height,0),btVector3(0,-height,0)};
	btScalar radi[numSpheres] = {radius,radius};
	void* mem = btAlignedAlloc(sizeof(btMultiSphereShape),16);
	return (PlCapsuleShape*) new (mem)btMultiSphereShape(positions,radi,numSpheres);
}
PlConeShape* pl_coneshape_new(PlReal radius, PlReal height)
{
	void* mem = btAlignedAlloc(sizeof(btConeShape),16);
	return (PlConeShape*) new (mem)btConeShape(radius,height);
}

PlCylinderShape* pl_cylindershape_new(PlReal radius, PlReal height)
{
	void* mem = btAlignedAlloc(sizeof(btCylinderShape),16);
	return (PlCylinderShape*) new (mem)btCylinderShape(btVector3(radius,height,radius));
}

/* Convex Meshes */
PlConvexHullShape* pl_convexhullshape_new()
{
	void* mem = btAlignedAlloc(sizeof(btConvexHullShape),16);
	return (PlConvexHullShape*) new (mem)btConvexHullShape();
}


/* Concave static triangle meshes */
PlMeshInterface*  pl_meshinterface_new()
{
	return 0;
}

PlCompoundShape* pl_compoundshape_new()
{
	void* mem = btAlignedAlloc(sizeof(btCompoundShape),16);
	return (PlCompoundShape*) new (mem)btCompoundShape();
}



void pl_SetEuler(PlReal yaw,PlReal pitch,PlReal roll, PlQuaternion* orient)
{
	btQuaternion orn;
	orn.setEuler(yaw,pitch,roll);
	orient[0] = orn.getX();
	orient[1] = orn.getY();
	orient[2] = orn.getZ();
	orient[3] = orn.getW();

}


//	extern  void		plAddTriangle(PlMeshInterface* mesh, PlVector3* v0,PlVector3* v1,PlVector3* v2);
//	extern  PlCollisionShape* plNewStaticTriangleMeshShape(PlMeshInterface*);


void pl_compoundshape_AddChildShape(PlCompoundShape* compoundShape,PlCollisionShape* childShape, PlVector3* childPos,PlQuaternion* childOrn)
{
	btCollisionShape* colShape = reinterpret_cast<btCollisionShape*>(compoundShape);
	btAssert(colShape->getShapeType() == COMPOUND_SHAPE_PROXYTYPE);
	btCompoundShape* compound = reinterpret_cast<btCompoundShape*>(colShape);
	btCollisionShape* child = reinterpret_cast<btCollisionShape*>(childShape);
	btTransform	localTrans;
	localTrans.setIdentity();
	localTrans.setOrigin(btVector3(childPos[0],childPos[1],childPos[2]));
	localTrans.setRotation(btQuaternion(childOrn[0],childOrn[1],childOrn[2],childOrn[3]));
	compound->addChildShape(localTrans,child);
}

void pl_convexhullshape_AddVertex(PlConvexHullShape* cshape, PlReal x,PlReal y,PlReal z)
{
	btCollisionShape* colShape = reinterpret_cast<btCollisionShape*>( cshape);
	(void)colShape;
	btAssert(colShape->getShapeType()==CONVEX_HULL_SHAPE_PROXYTYPE);
	btConvexHullShape* convexHullShape = reinterpret_cast<btConvexHullShape*>( cshape);
	convexHullShape->addPoint(btVector3(x,y,z));

}

void pl_collisionshape_free(PlCollisionShape* cshape)
{
	CAST_ASSERT(cshape,btCollisionShape*,shape);

	btAlignedFree(shape);
}
void pl_collisionshape_SetScaling(PlCollisionShape* cshape, PlVector3* cscaling)
{
	CAST_ASSERT(cshape,btCollisionShape*,shape);

	btVector3 scaling(cscaling[0],cscaling[1],cscaling[2]);
	shape->setLocalScaling(scaling);	
}



void pl_rigidbody_SetPosition(PlRigidBody* object, const PlVector3* position)
{
	CAST_ASSERT(object,btRigidBody*,body);

	btVector3 pos(position[0],position[1],position[2]);
	btTransform worldTrans = body->getWorldTransform();
	worldTrans.setOrigin(pos);
	body->setWorldTransform(worldTrans);
}

void pl_rigidbody_SetOrientation(PlRigidBody* object, const PlQuaternion* orientation)
{
	CAST_ASSERT(object,btRigidBody*,body);

	btQuaternion orn(orientation[0],orientation[1],orientation[2],orientation[3]);
	btTransform worldTrans = body->getWorldTransform();
	worldTrans.setRotation(orn);
	body->setWorldTransform(worldTrans);
}

void pl_rigidbody_SetOpenGLMatrix(PlRigidBody* object, PlReal* matrix)
{
	CAST_ASSERT(object,btRigidBody*,body);

	btTransform& worldTrans = body->getWorldTransform();
	worldTrans.setFromOpenGLMatrix(matrix);
}

void pl_rigidbody_GetOpenGLMatrix(PlRigidBody* object, PlReal* matrix)
{
	CAST_ASSERT(object,btRigidBody*,body);

	body->getWorldTransform().getOpenGLMatrix(matrix);

}

void pl_rigidbody_GetPosition(PlRigidBody* object,PlVector3* position)
{
	CAST_ASSERT(object,btRigidBody*,body);

	const btVector3& pos = body->getWorldTransform().getOrigin();
	position[0] = pos.getX();
	position[1] = pos.getY();
	position[2] = pos.getZ();
}

void pl_rigidbody_GetOrientation(PlRigidBody* object,PlQuaternion* orientation)
{
	CAST_ASSERT(object,btRigidBody*,body);

	const btQuaternion& orn = body->getWorldTransform().getRotation();
	orientation[0] = orn.getX();
	orientation[1] = orn.getY();
	orientation[2] = orn.getZ();
	orientation[3] = orn.getW();
}



//PlRigidBody* plRayCast(PlDynamicsWorld* world, const PlVector3* rayStart, const PlVector3* rayEnd, PlVector3* hitpoint, PlVector3* normal);

//	extern  PlRigidBody* plObjectCast(PlDynamicsWorld* world, const PlVector3* rayStart, const PlVector3* rayEnd, PlVector3* hitpoint, PlVector3* normal);

double plNearestPoints(float p1[3], float p2[3], float p3[3], float q1[3], float q2[3], float q3[3], float *pa, float *pb, float normal[3])
{
	btVector3 vp(p1[0], p1[1], p1[2]);
	btTriangleShape trishapeA(vp, 
				  btVector3(p2[0], p2[1], p2[2]), 
				  btVector3(p3[0], p3[1], p3[2]));
	trishapeA.setMargin(0.000001f);
	btVector3 vq(q1[0], q1[1], q1[2]);
	btTriangleShape trishapeB(vq, 
				  btVector3(q2[0], q2[1], q2[2]), 
				  btVector3(q3[0], q3[1], q3[2]));
	trishapeB.setMargin(0.000001f);
	
	// btVoronoiSimplexSolver sGjkSimplexSolver;
	// btGjkEpaPenetrationDepthSolver penSolverPtr;	
	
	static btSimplexSolverInterface sGjkSimplexSolver;
	sGjkSimplexSolver.reset();
	
	static btGjkEpaPenetrationDepthSolver Solver0;
	static btMinkowskiPenetrationDepthSolver Solver1;
		
	btConvexPenetrationDepthSolver* Solver = NULL;
	
	Solver = &Solver1;	
		
	btGjkPairDetector convexConvex(&trishapeA ,&trishapeB,&sGjkSimplexSolver,Solver);
	
	convexConvex.m_catchDegeneracies = 1;
	
	// btGjkPairDetector convexConvex(&trishapeA ,&trishapeB,&sGjkSimplexSolver,0);
	
	btPointCollector gjkOutput;
	btGjkPairDetector::ClosestPointInput input;
	
		
	btTransform tr;
	tr.setIdentity();
	
	input.m_transformA = tr;
	input.m_transformB = tr;
	
	convexConvex.getClosestPoints(input, gjkOutput, 0);
	
	
	if (gjkOutput.m_hasResult)
	{
		
		pb[0] = pa[0] = gjkOutput.m_pointInWorld[0];
		pb[1] = pa[1] = gjkOutput.m_pointInWorld[1];
		pb[2] = pa[2] = gjkOutput.m_pointInWorld[2];

		pb[0]+= gjkOutput.m_normalOnBInWorld[0] * gjkOutput.m_distance;
		pb[1]+= gjkOutput.m_normalOnBInWorld[1] * gjkOutput.m_distance;
		pb[2]+= gjkOutput.m_normalOnBInWorld[2] * gjkOutput.m_distance;
		
		normal[0] = gjkOutput.m_normalOnBInWorld[0];
		normal[1] = gjkOutput.m_normalOnBInWorld[1];
		normal[2] = gjkOutput.m_normalOnBInWorld[2];

		return gjkOutput.m_distance;
	}
	return -1.0f;	
}

