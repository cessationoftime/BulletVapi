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

	If possible, use the richer Bullet C++ API, by including "btBulletDynamicsCommon.h"
*/

#ifndef BULLET_C_API_H
#define BULLET_C_API_H


#define PL_DECLARE_HANDLE(name) typedef struct pl_##name { int unused; } Pl##name
#define PL_DECLARE_INHERIT(base,name) typedef Pl##base Pl##name

#ifdef BT_USE_DOUBLE_PRECISION
typedef double	PlReal;
#else
typedef float	PlReal;
#endif
typedef PlReal	PlVector3;

typedef PlReal	PlQuaternion;





#ifdef __cplusplus
extern "C" { 
#endif

/**	Particular physics SDK (C-API) */
	PL_DECLARE_HANDLE(PhysicsSdk);

/** 	Dynamics world, belonging to some physics SDK (C-API)*/
	PL_DECLARE_HANDLE(DynamicsWorld);



/** Rigid Body that can be part of a Dynamics World (C-API)*/	
	PL_DECLARE_HANDLE(RigidBody);

/** 	Collision Shape/Geometry, property of a Rigid Body (C-API)*/
	PL_DECLARE_HANDLE(CollisionShape);
	PL_DECLARE_INHERIT(CollisionShape,CompoundShape);
	PL_DECLARE_INHERIT(CollisionShape,CylinderShape);
	PL_DECLARE_INHERIT(CollisionShape,ConeShape);
	PL_DECLARE_INHERIT(CollisionShape,CapsuleShape);
	PL_DECLARE_INHERIT(CollisionShape,BoxShape);
	PL_DECLARE_INHERIT(CollisionShape,SphereShape);
	PL_DECLARE_INHERIT(CollisionShape,ConvexHullShape);
	PL_DECLARE_INHERIT(CollisionShape,TriangleMeshShape);


/** Constraint for Rigid Bodies (C-API)*/
	PL_DECLARE_HANDLE(Constraint);

/** Triangle Mesh interface (C-API)*/
	PL_DECLARE_HANDLE(MeshInterface);

/** Broadphase Scene/Proxy Handles (C-API)*/
	PL_DECLARE_HANDLE(CollisionBroadphase);
	PL_DECLARE_HANDLE(BroadphaseProxy);
	PL_DECLARE_HANDLE(CollisionWorld);

extern PlVector3* pl_vector3_new();
extern PlVector3* pl_vector3_new_xyz(PlReal x, PlReal y, PlReal z);
extern  PlReal pl_vector3_get_x(PlVector3* v);
extern  PlReal pl_vector3_get_y(PlVector3* v);
extern  PlReal pl_vector3_get_z(PlVector3* v);
extern void pl_vector3_free(PlVector3* v);

extern PlQuaternion* pl_quaternion_new();
extern PlQuaternion* pl_quaternion_new_xyzw(PlReal x, PlReal y, PlReal z, PlReal w);
extern  PlReal pl_quaternion_get_x(PlQuaternion* v);
extern  PlReal pl_quaternion_get_y(PlQuaternion* v);
extern  PlReal pl_quaternion_get_z(PlQuaternion* v);
extern  PlReal pl_quaternion_get_w(PlQuaternion* v);
extern void pl_quaternion_free(PlQuaternion* v);

/**
	Create and Delete a Physics SDK	
*/

 PlPhysicsSdk*	pl_physicssdk_new(void);
//void plDeletePhysicsSdk(PhysicsSdk* physicsSdk);
 void pl_physicssdk_free(PlPhysicsSdk* physicsSdk);


/** Collision World, not strictly necessary, you can also just create a Dynamics World with Rigid Bodies which internally manages the Collision World with Collision Objects */

	typedef void(*btBroadphaseCallback)(void* clientData, void* object1,void* object2);

	extern PlCollisionBroadphase	pl_SapBroadphase_new(btBroadphaseCallback beginCallback,btBroadphaseCallback endCallback);

	extern void	pl_collisionbroadphase_free(PlCollisionBroadphase* bp);

	extern 	PlBroadphaseProxy* pl_broadphaseproxy_new(PlCollisionBroadphase* bp, void* clientData, PlReal minX,PlReal minY,PlReal minZ, PlReal maxX,PlReal maxY, PlReal maxZ);

	extern void pl_broadphaseproxy_free(PlCollisionBroadphase* bp, PlBroadphaseProxy* proxy);

	extern void pl_broadphaseproxy_SetBoundingBox(PlBroadphaseProxy* proxy, PlReal minX,PlReal minY,PlReal minZ, PlReal maxX,PlReal maxY, PlReal maxZ);

/* todo: add pair cache support with queries like add/remove/find pair */
	
	extern PlCollisionWorld* pl_collisionworld_new(PlPhysicsSdk* physicsSdk);

/* todo: add/remove objects */
	

/* Dynamics World */
	extern  PlDynamicsWorld* pl_dynamicsworld_new(PlPhysicsSdk* physicsSdk);
	extern  void  pl_dynamicsworld_free(PlDynamicsWorld* world);
	extern	void  pl_dynamicsworld_StepSimulation(PlDynamicsWorld* world,	PlReal	timeStep);
	extern  void pl_dynamicsworld_AddRigidBody(PlDynamicsWorld* world, PlRigidBody* object);
	extern  void pl_dynamicsworld_RemoveRigidBody(PlDynamicsWorld* world, PlRigidBody* object);


/* Rigid Body  */

	extern  PlRigidBody* pl_rigidbody_new(	void* user_data,  float mass, PlCollisionShape* cshape );

	extern  void pl_rigidbody_free(PlRigidBody* body);


/* Collision Shape definition */

	extern  PlSphereShape* pl_sphereshape_new(PlReal radius);
	extern  PlBoxShape* pl_boxshape_new(PlReal x, PlReal y, PlReal z);
	extern  PlCapsuleShape* pl_capsuleshape_new(PlReal radius, PlReal height);	
	extern  PlConeShape* pl_coneshape_new(PlReal radius, PlReal height);
	extern  PlCylinderShape* pl_cylindershape_new(PlReal radius, PlReal height);
	extern	PlCompoundShape* pl_compoundshape_new();
	

	extern	void	pl_compoundshape_AddChildShape(PlCompoundShape* compoundShape,PlCollisionShape* childShape, PlVector3* childPos,PlQuaternion* childOrn);


	extern  void pl_collisionshape_free(PlCollisionShape* shape);

	/* Convex Meshes */
	extern  PlConvexHullShape* pl_convexhullshape_new();
	extern  void pl_convexhullshape_AddVertex(PlConvexHullShape* convexHull, PlReal x,PlReal y,PlReal z);






/* Concave static triangle meshes */
	extern  PlMeshInterface*   pl_meshinterface_new();
	extern  void		pl_meshinterface_AddTriangle(PlMeshInterface* mesh, PlVector3* v0,PlVector3* v1,PlVector3* v2);
	extern  PlTriangleMeshShape* pl_trianglemeshshape_new(PlMeshInterface);

	extern  void pl_collisionshape_SetScaling(PlCollisionShape* shape, PlVector3* scaling);

/* SOLID has Response Callback/Table/Management */
/* PhysX has Triggers, User Callbacks and filtering */
/* ODE has the typedef void dNearCallback (void *data, dGeomID o1, dGeomID o2); */

/*	typedef void plUpdatedPositionCallback(void* userData, plRigidBody	rb, PlVector3* pos); */
/*	typedef void plUpdatedOrientationCallback(void* userData, plRigidBody	rb, PlQuaternion orientation); */

	/* get world transform */
	extern void	pl_rigidbody_GetOpenGLMatrix(PlRigidBody* object, PlReal* matrix);
	extern void	pl_rigidbody_GetPosition(PlRigidBody* object,PlVector3* position);
	extern void pl_rigidbody_GetOrientation(PlRigidBody* object,PlQuaternion* orientation);

	/* set world transform (position/orientation) */
	extern  void pl_rigidbody_SetPosition(PlRigidBody* object, const PlVector3* position);
	extern  void pl_rigidbody_SetOrientation(PlRigidBody* object, const PlQuaternion* orientation);
	extern	void pl_SetEuler(PlReal yaw,PlReal pitch,PlReal roll, PlQuaternion* orient);
	extern	void pl_rigidbody_SetOpenGLMatrix(PlRigidBody* object, PlReal* matrix);

	typedef struct pl_RayCastResult {
		PlRigidBody*		m_body;  
		PlCollisionShape*	m_shape; 		
		PlVector3*				m_positionWorld; 		
		PlVector3*				m_normalWorld;
	} PlRayCastResult;


	extern  int pl_dynamicsworld_RayCast(PlDynamicsWorld* world, const PlVector3* rayStart, const PlVector3* rayEnd, PlRayCastResult res);

	/* Sweep API */

	/* extern  plRigidBody* plObjectCast(PlDynamicsWorld* world, const PlVector3* rayStart, const PlVector3* rayEnd, PlVector3* hitpoint, PlVector3* normal); */

	/* Continuous Collision Detection API */
	
	// needed for source/blender/blenkernel/intern/collision.c
	extern double pl_NearestPoints(float p1[3], float p2[3], float p3[3], float q1[3], float q2[3], float q3[3], float *pa, float *pb, float normal[3]);

#ifdef __cplusplus
}
#endif


#endif //BULLET_C_API_H

