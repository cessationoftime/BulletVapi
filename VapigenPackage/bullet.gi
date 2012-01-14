<?xml version="1.0"?>
<api version="1.0">
	<namespace name="Pl">
		<function name="NearestPoints" symbol="pl_NearestPoints">
			<return-type type="double"/>
			<parameters>
				<parameter name="p1" type="float[]"/>
				<parameter name="p2" type="float[]"/>
				<parameter name="p3" type="float[]"/>
				<parameter name="q1" type="float[]"/>
				<parameter name="q2" type="float[]"/>
				<parameter name="q3" type="float[]"/>
				<parameter name="pa" type="float*"/>
				<parameter name="pb" type="float*"/>
				<parameter name="normal" type="float[]"/>
			</parameters>
		</function>
		<function name="SapBroadphase_new" symbol="pl_SapBroadphase_new">
			<return-type type="PlCollisionBroadphase"/>
			<parameters>
				<parameter name="beginCallback" type="btBroadphaseCallback"/>
				<parameter name="endCallback" type="btBroadphaseCallback"/>
			</parameters>
		</function>
		<function name="SetEuler" symbol="pl_SetEuler">
			<return-type type="void"/>
			<parameters>
				<parameter name="yaw" type="PlReal"/>
				<parameter name="pitch" type="PlReal"/>
				<parameter name="roll" type="PlReal"/>
				<parameter name="orient" type="PlQuaternion*"/>
			</parameters>
		</function>
		<callback name="btBroadphaseCallback">
			<return-type type="void"/>
			<parameters>
				<parameter name="clientData" type="void*"/>
				<parameter name="object1" type="void*"/>
				<parameter name="object2" type="void*"/>
			</parameters>
		</callback>
		<struct name="PlBoxShape">
			<method name="new" symbol="pl_boxshape_new">
				<return-type type="PlBoxShape*"/>
				<parameters>
					<parameter name="x" type="PlReal"/>
					<parameter name="y" type="PlReal"/>
					<parameter name="z" type="PlReal"/>
				</parameters>
			</method>
		</struct>
		<struct name="PlBroadphaseProxy">
			<method name="SetBoundingBox" symbol="pl_broadphaseproxy_SetBoundingBox">
				<return-type type="void"/>
				<parameters>
					<parameter name="proxy" type="PlBroadphaseProxy*"/>
					<parameter name="minX" type="PlReal"/>
					<parameter name="minY" type="PlReal"/>
					<parameter name="minZ" type="PlReal"/>
					<parameter name="maxX" type="PlReal"/>
					<parameter name="maxY" type="PlReal"/>
					<parameter name="maxZ" type="PlReal"/>
				</parameters>
			</method>
			<method name="free" symbol="pl_broadphaseproxy_free">
				<return-type type="void"/>
				<parameters>
					<parameter name="bp" type="PlCollisionBroadphase*"/>
					<parameter name="proxy" type="PlBroadphaseProxy*"/>
				</parameters>
			</method>
			<method name="new" symbol="pl_broadphaseproxy_new">
				<return-type type="PlBroadphaseProxy*"/>
				<parameters>
					<parameter name="bp" type="PlCollisionBroadphase*"/>
					<parameter name="clientData" type="void*"/>
					<parameter name="minX" type="PlReal"/>
					<parameter name="minY" type="PlReal"/>
					<parameter name="minZ" type="PlReal"/>
					<parameter name="maxX" type="PlReal"/>
					<parameter name="maxY" type="PlReal"/>
					<parameter name="maxZ" type="PlReal"/>
				</parameters>
			</method>
			<field name="unused" type="int"/>
		</struct>
		<struct name="PlCapsuleShape">
			<method name="new" symbol="pl_capsuleshape_new">
				<return-type type="PlCapsuleShape*"/>
				<parameters>
					<parameter name="radius" type="PlReal"/>
					<parameter name="height" type="PlReal"/>
				</parameters>
			</method>
		</struct>
		<struct name="PlCollisionBroadphase">
			<method name="free" symbol="pl_collisionbroadphase_free">
				<return-type type="void"/>
				<parameters>
					<parameter name="bp" type="PlCollisionBroadphase*"/>
				</parameters>
			</method>
			<field name="unused" type="int"/>
		</struct>
		<struct name="PlCollisionShape">
			<method name="SetScaling" symbol="pl_collisionshape_SetScaling">
				<return-type type="void"/>
				<parameters>
					<parameter name="shape" type="PlCollisionShape*"/>
					<parameter name="scaling" type="PlVector3*"/>
				</parameters>
			</method>
			<method name="free" symbol="pl_collisionshape_free">
				<return-type type="void"/>
				<parameters>
					<parameter name="shape" type="PlCollisionShape*"/>
				</parameters>
			</method>
			<field name="unused" type="int"/>
		</struct>
		<struct name="PlCollisionWorld">
			<method name="new" symbol="pl_collisionworld_new">
				<return-type type="PlCollisionWorld*"/>
				<parameters>
					<parameter name="physicsSdk" type="PlPhysicsSdk*"/>
				</parameters>
			</method>
			<field name="unused" type="int"/>
		</struct>
		<struct name="PlCompoundShape">
			<method name="AddChildShape" symbol="pl_compoundshape_AddChildShape">
				<return-type type="void"/>
				<parameters>
					<parameter name="compoundShape" type="PlCompoundShape*"/>
					<parameter name="childShape" type="PlCollisionShape*"/>
					<parameter name="childPos" type="PlVector3*"/>
					<parameter name="childOrn" type="PlQuaternion*"/>
				</parameters>
			</method>
			<method name="new" symbol="pl_compoundshape_new">
				<return-type type="PlCompoundShape*"/>
			</method>
		</struct>
		<struct name="PlConeShape">
			<method name="new" symbol="pl_coneshape_new">
				<return-type type="PlConeShape*"/>
				<parameters>
					<parameter name="radius" type="PlReal"/>
					<parameter name="height" type="PlReal"/>
				</parameters>
			</method>
		</struct>
		<struct name="PlConstraint">
			<field name="unused" type="int"/>
		</struct>
		<struct name="PlConvexHullShape">
			<method name="AddVertex" symbol="pl_convexhullshape_AddVertex">
				<return-type type="void"/>
				<parameters>
					<parameter name="convexHull" type="PlConvexHullShape*"/>
					<parameter name="x" type="PlReal"/>
					<parameter name="y" type="PlReal"/>
					<parameter name="z" type="PlReal"/>
				</parameters>
			</method>
			<method name="new" symbol="pl_convexhullshape_new">
				<return-type type="PlConvexHullShape*"/>
			</method>
		</struct>
		<struct name="PlCylinderShape">
			<method name="new" symbol="pl_cylindershape_new">
				<return-type type="PlCylinderShape*"/>
				<parameters>
					<parameter name="radius" type="PlReal"/>
					<parameter name="height" type="PlReal"/>
				</parameters>
			</method>
		</struct>
		<struct name="PlDynamicsWorld">
			<method name="AddRigidBody" symbol="pl_dynamicsworld_AddRigidBody">
				<return-type type="void"/>
				<parameters>
					<parameter name="world" type="PlDynamicsWorld*"/>
					<parameter name="object" type="PlRigidBody*"/>
				</parameters>
			</method>
			<method name="RayCast" symbol="pl_dynamicsworld_RayCast">
				<return-type type="int"/>
				<parameters>
					<parameter name="world" type="PlDynamicsWorld*"/>
					<parameter name="rayStart" type="PlVector3*"/>
					<parameter name="rayEnd" type="PlVector3*"/>
					<parameter name="res" type="PlRayCastResult"/>
				</parameters>
			</method>
			<method name="RemoveRigidBody" symbol="pl_dynamicsworld_RemoveRigidBody">
				<return-type type="void"/>
				<parameters>
					<parameter name="world" type="PlDynamicsWorld*"/>
					<parameter name="object" type="PlRigidBody*"/>
				</parameters>
			</method>
			<method name="StepSimulation" symbol="pl_dynamicsworld_StepSimulation">
				<return-type type="void"/>
				<parameters>
					<parameter name="world" type="PlDynamicsWorld*"/>
					<parameter name="timeStep" type="PlReal"/>
				</parameters>
			</method>
			<method name="free" symbol="pl_dynamicsworld_free">
				<return-type type="void"/>
				<parameters>
					<parameter name="world" type="PlDynamicsWorld*"/>
				</parameters>
			</method>
			<method name="new" symbol="pl_dynamicsworld_new">
				<return-type type="PlDynamicsWorld*"/>
				<parameters>
					<parameter name="physicsSdk" type="PlPhysicsSdk*"/>
				</parameters>
			</method>
			<field name="unused" type="int"/>
		</struct>
		<struct name="PlMeshInterface">
			<method name="AddTriangle" symbol="pl_meshinterface_AddTriangle">
				<return-type type="void"/>
				<parameters>
					<parameter name="mesh" type="PlMeshInterface*"/>
					<parameter name="v0" type="PlVector3*"/>
					<parameter name="v1" type="PlVector3*"/>
					<parameter name="v2" type="PlVector3*"/>
				</parameters>
			</method>
			<method name="new" symbol="pl_meshinterface_new">
				<return-type type="PlMeshInterface*"/>
			</method>
			<field name="unused" type="int"/>
		</struct>
		<struct name="PlPhysicsSdk">
			<method name="free" symbol="pl_physicssdk_free">
				<return-type type="void"/>
				<parameters>
					<parameter name="physicsSdk" type="PlPhysicsSdk*"/>
				</parameters>
			</method>
			<method name="new" symbol="pl_physicssdk_new">
				<return-type type="PlPhysicsSdk*"/>
			</method>
			<field name="unused" type="int"/>
		</struct>
		<struct name="PlQuaternion">
			<method name="free" symbol="pl_quaternion_free">
				<return-type type="void"/>
				<parameters>
					<parameter name="v" type="PlQuaternion*"/>
				</parameters>
			</method>
			<method name="get_w" symbol="pl_quaternion_get_w">
				<return-type type="PlReal"/>
				<parameters>
					<parameter name="v" type="PlQuaternion*"/>
				</parameters>
			</method>
			<method name="get_x" symbol="pl_quaternion_get_x">
				<return-type type="PlReal"/>
				<parameters>
					<parameter name="v" type="PlQuaternion*"/>
				</parameters>
			</method>
			<method name="get_y" symbol="pl_quaternion_get_y">
				<return-type type="PlReal"/>
				<parameters>
					<parameter name="v" type="PlQuaternion*"/>
				</parameters>
			</method>
			<method name="get_z" symbol="pl_quaternion_get_z">
				<return-type type="PlReal"/>
				<parameters>
					<parameter name="v" type="PlQuaternion*"/>
				</parameters>
			</method>
			<method name="new" symbol="pl_quaternion_new">
				<return-type type="PlQuaternion*"/>
			</method>
			<method name="new_xyzw" symbol="pl_quaternion_new_xyzw">
				<return-type type="PlQuaternion*"/>
				<parameters>
					<parameter name="x" type="PlReal"/>
					<parameter name="y" type="PlReal"/>
					<parameter name="z" type="PlReal"/>
					<parameter name="w" type="PlReal"/>
				</parameters>
			</method>
		</struct>
		<struct name="PlRayCastResult">
			<field name="m_body" type="PlRigidBody*"/>
			<field name="m_shape" type="PlCollisionShape*"/>
			<field name="m_positionWorld" type="PlVector3*"/>
			<field name="m_normalWorld" type="PlVector3*"/>
		</struct>
		<struct name="PlReal">
		</struct>
		<struct name="PlRigidBody">
			<method name="GetOpenGLMatrix" symbol="pl_rigidbody_GetOpenGLMatrix">
				<return-type type="void"/>
				<parameters>
					<parameter name="object" type="PlRigidBody*"/>
					<parameter name="matrix" type="PlReal*"/>
				</parameters>
			</method>
			<method name="GetOrientation" symbol="pl_rigidbody_GetOrientation">
				<return-type type="void"/>
				<parameters>
					<parameter name="object" type="PlRigidBody*"/>
					<parameter name="orientation" type="PlQuaternion*"/>
				</parameters>
			</method>
			<method name="GetPosition" symbol="pl_rigidbody_GetPosition">
				<return-type type="void"/>
				<parameters>
					<parameter name="object" type="PlRigidBody*"/>
					<parameter name="position" type="PlVector3*"/>
				</parameters>
			</method>
			<method name="SetOpenGLMatrix" symbol="pl_rigidbody_SetOpenGLMatrix">
				<return-type type="void"/>
				<parameters>
					<parameter name="object" type="PlRigidBody*"/>
					<parameter name="matrix" type="PlReal*"/>
				</parameters>
			</method>
			<method name="SetOrientation" symbol="pl_rigidbody_SetOrientation">
				<return-type type="void"/>
				<parameters>
					<parameter name="object" type="PlRigidBody*"/>
					<parameter name="orientation" type="PlQuaternion*"/>
				</parameters>
			</method>
			<method name="SetPosition" symbol="pl_rigidbody_SetPosition">
				<return-type type="void"/>
				<parameters>
					<parameter name="object" type="PlRigidBody*"/>
					<parameter name="position" type="PlVector3*"/>
				</parameters>
			</method>
			<method name="free" symbol="pl_rigidbody_free">
				<return-type type="void"/>
				<parameters>
					<parameter name="body" type="PlRigidBody*"/>
				</parameters>
			</method>
			<method name="new" symbol="pl_rigidbody_new">
				<return-type type="PlRigidBody*"/>
				<parameters>
					<parameter name="user_data" type="void*"/>
					<parameter name="mass" type="float"/>
					<parameter name="cshape" type="PlCollisionShape*"/>
				</parameters>
			</method>
			<field name="unused" type="int"/>
		</struct>
		<struct name="PlSphereShape">
			<method name="new" symbol="pl_sphereshape_new">
				<return-type type="PlSphereShape*"/>
				<parameters>
					<parameter name="radius" type="PlReal"/>
				</parameters>
			</method>
		</struct>
		<struct name="PlTriangleMeshShape">
			<method name="new" symbol="pl_trianglemeshshape_new">
				<return-type type="PlTriangleMeshShape*"/>
				<parameters>
					<parameter name="p1" type="PlMeshInterface"/>
				</parameters>
			</method>
		</struct>
		<struct name="PlVector3">
			<method name="free" symbol="pl_vector3_free">
				<return-type type="void"/>
				<parameters>
					<parameter name="v" type="PlVector3*"/>
				</parameters>
			</method>
			<method name="get_x" symbol="pl_vector3_get_x">
				<return-type type="PlReal"/>
				<parameters>
					<parameter name="v" type="PlVector3*"/>
				</parameters>
			</method>
			<method name="get_y" symbol="pl_vector3_get_y">
				<return-type type="PlReal"/>
				<parameters>
					<parameter name="v" type="PlVector3*"/>
				</parameters>
			</method>
			<method name="get_z" symbol="pl_vector3_get_z">
				<return-type type="PlReal"/>
				<parameters>
					<parameter name="v" type="PlVector3*"/>
				</parameters>
			</method>
			<method name="new" symbol="pl_vector3_new">
				<return-type type="PlVector3*"/>
			</method>
			<method name="new_xyz" symbol="pl_vector3_new_xyz">
				<return-type type="PlVector3*"/>
				<parameters>
					<parameter name="x" type="PlReal"/>
					<parameter name="y" type="PlReal"/>
					<parameter name="z" type="PlReal"/>
				</parameters>
			</method>
		</struct>
	</namespace>
</api>
