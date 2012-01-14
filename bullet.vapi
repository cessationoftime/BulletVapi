/* bullet.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "Pl", lower_case_cprefix = "pl_")]
namespace Pl {
	[Compact]
	[CCode (free_function = "pl_collisionshape_free", cheader_filename = "Bullet-C-Api.h")]
	public class BoxShape : Pl.CollisionShape {
		[CCode (cname = "pl_boxshape_new", has_construct_function = false)]
		public BoxShape (Pl.Real x, Pl.Real y, Pl.Real z);
	}
	[Compact]
	[CCode (free_function = "pl_broadphaseproxy_free", cheader_filename = "Bullet-C-Api.h")]
	public class BroadphaseProxy {
		[CCode (cname = "pl_broadphaseproxy_new", has_construct_function = false)]
		public BroadphaseProxy (Pl.CollisionBroadphase bp, void* clientData, Pl.Real minX, Pl.Real minY, Pl.Real minZ, Pl.Real maxX, Pl.Real maxY, Pl.Real maxZ);
		[CCode (cname = "pl_broadphaseproxy_SetBoundingBox")]
		public void SetBoundingBox (Pl.Real minX, Pl.Real minY, Pl.Real minZ, Pl.Real maxX, Pl.Real maxY, Pl.Real maxZ);
	}
	[Compact]
	[CCode (free_function = "pl_collisionshape_free", cheader_filename = "Bullet-C-Api.h")]
	public class CapsuleShape : Pl.CollisionShape {
		[CCode (cname = "pl_capsuleshape_new", has_construct_function = false)]
		public CapsuleShape (Pl.Real radius, Pl.Real height);
	}
	[Compact]
	[CCode (free_function = "pl_collisionbroadphase_free", cheader_filename = "Bullet-C-Api.h")]
	public class CollisionBroadphase {
	}
	[Compact]
	[CCode (free_function = "pl_collisionshape_free", cheader_filename = "Bullet-C-Api.h")]
	public class CollisionShape {
		[CCode (cname = "pl_collisionshape_SetScaling")]
		public void SetScaling (Pl.Vector3 scaling);
	}
	[Compact]
	[CCode (cheader_filename = "Bullet-C-Api.h")]
	public class CollisionWorld {
		[CCode (cname = "pl_collisionworld_new", has_construct_function = false)]
		public CollisionWorld (Pl.PhysicsSdk physicsSdk);
	}
	[Compact]
	[CCode (free_function = "pl_collisionshape_free", cheader_filename = "Bullet-C-Api.h")]
	public class CompoundShape : Pl.CollisionShape {
		[CCode (cname = "pl_compoundshape_new", has_construct_function = false)]
		public CompoundShape ();
		[CCode (cname = "pl_compoundshape_AddChildShape")]
		public void AddChildShape (Pl.CollisionShape childShape, Pl.Vector3 childPos, Pl.Quaternion childOrn);
	}
	[Compact]
	[CCode (free_function = "pl_collisionshape_free", cheader_filename = "Bullet-C-Api.h")]
	public class ConeShape : Pl.CollisionShape {
		[CCode (cname = "pl_coneshape_new", has_construct_function = false)]
		public ConeShape (Pl.Real radius, Pl.Real height);
	}
	[Compact]
	[CCode (cheader_filename = "Bullet-C-Api.h")]
	public class Constraint {
	}
	[Compact]
	[CCode (free_function = "pl_collisionshape_free", cheader_filename = "Bullet-C-Api.h")]
	public class ConvexHullShape : Pl.CollisionShape {
		[CCode (cname = "pl_convexhullshape_new", has_construct_function = false)]
		public ConvexHullShape ();
		[CCode (cname = "pl_convexhullshape_AddVertex")]
		public void AddVertex (Pl.Real x, Pl.Real y, Pl.Real z);
	}
	[Compact]
	[CCode (free_function = "pl_collisionshape_free", cheader_filename = "Bullet-C-Api.h")]
	public class CylinderShape : Pl.CollisionShape {
		[CCode (cname = "pl_cylindershape_new", has_construct_function = false)]
		public CylinderShape (Pl.Real radius, Pl.Real height);
	}
	[Compact]
	[CCode (free_function = "pl_dynamicsworld_free", cheader_filename = "Bullet-C-Api.h")]
	public class DynamicsWorld {
		[CCode (cname = "pl_dynamicsworld_new", has_construct_function = false)]
		public DynamicsWorld (Pl.PhysicsSdk physicsSdk);
		[CCode (cname = "pl_dynamicsworld_AddRigidBody")]
		public void AddRigidBody (Pl.RigidBody object);
		[CCode (cname = "pl_dynamicsworld_RayCast")]
		public int RayCast (Pl.Vector3 rayStart, Pl.Vector3 rayEnd, Pl.RayCastResult res);
		[CCode (cname = "pl_dynamicsworld_RemoveRigidBody")]
		public void RemoveRigidBody (Pl.RigidBody object);
		[CCode (cname = "pl_dynamicsworld_StepSimulation")]
		public void StepSimulation (Pl.Real timeStep);
	}
	[Compact]
	[CCode (cheader_filename = "Bullet-C-Api.h")]
	public class MeshInterface {
		[CCode (cname = "pl_meshinterface_new", has_construct_function = false)]
		public MeshInterface ();
		[CCode (cname = "pl_meshinterface_AddTriangle")]
		public void AddTriangle (Pl.Vector3 v0, Pl.Vector3 v1, Pl.Vector3 v2);
	}
	[Compact]
	[CCode (free_function = "pl_physicssdk_free", cheader_filename = "Bullet-C-Api.h")]
	public class PhysicsSdk {
		[CCode (cname = "pl_physicssdk_new", has_construct_function = false)]
		public PhysicsSdk ();
	}
	[Compact]
	[CCode (cheader_filename = "Bullet-C-Api.h")]
	public class Quaternion {
		[CCode (has_construct_function = false)]
		public Quaternion ();
		public Pl.Real get_w ();
		public Pl.Real get_x ();
		public Pl.Real get_y ();
		public Pl.Real get_z ();
		[CCode (has_construct_function = false)]
		public Quaternion.xyzw (Pl.Real x, Pl.Real y, Pl.Real z, Pl.Real w);
	}
	[Compact]
	[CCode (cheader_filename = "Bullet-C-Api.h")]
	public class RayCastResult {
		public weak Pl.RigidBody m_body;
		public weak Pl.Vector3 m_normalWorld;
		public weak Pl.Vector3 m_positionWorld;
		public weak Pl.CollisionShape m_shape;
	}
	[Compact]
	[CCode (free_function = "pl_rigidbody_free", cheader_filename = "Bullet-C-Api.h")]
	public class RigidBody {
		[CCode (cname = "pl_rigidbody_new", has_construct_function = false)]
		public RigidBody (void* user_data, float mass, Pl.CollisionShape cshape);
		[CCode (cname = "pl_rigidbody_GetOpenGLMatrix")]
		public void GetOpenGLMatrix ([CCode (array_length = false)] Pl.Real[] matrix);
		[CCode (cname = "pl_rigidbody_GetOrientation")]
		public void GetOrientation (Pl.Quaternion orientation);
		[CCode (cname = "pl_rigidbody_GetPosition")]
		public void GetPosition (Pl.Vector3 position);
		[CCode (cname = "pl_rigidbody_SetOpenGLMatrix")]
		public void SetOpenGLMatrix ([CCode (array_length = false)] Pl.Real[] matrix);
		[CCode (cname = "pl_rigidbody_SetOrientation")]
		public void SetOrientation (Pl.Quaternion orientation);
		[CCode (cname = "pl_rigidbody_SetPosition")]
		public void SetPosition (Pl.Vector3 position);
	}
	[Compact]
	[CCode (cheader_filename = "Bullet-C-Api.h")]
	public class SphereShape {
		[CCode (cname = "pl_sphereshape_new", has_construct_function = false)]
		public SphereShape (Pl.Real radius);
	}
	[Compact]
	[CCode (cheader_filename = "Bullet-C-Api.h")]
	public class TriangleMeshShape {
		[CCode (cname = "pl_trianglemeshshape_new", has_construct_function = false)]
		public TriangleMeshShape (Pl.MeshInterface p1);
	}
	[Compact]
	[CCode (cheader_filename = "Bullet-C-Api.h")]
	public class Vector3 {
		[CCode (has_construct_function = false)]
		public Vector3 ();
		public Pl.Real get_x ();
		public Pl.Real get_y ();
		public Pl.Real get_z ();
		[CCode (has_construct_function = false)]
		public Vector3.xyz (Pl.Real x, Pl.Real y, Pl.Real z);
	}
	[CCode (cheader_filename = "Bullet-C-Api.h")]
	[SimpleType]
	[FloatingType (rank = 0)]
	public struct Real : float {
	}
	[CCode (cheader_filename = "Bullet-C-Api.h", has_target = false)]
	public delegate void btBroadphaseCallback (void* clientData, void* object1, void* object2);
	[CCode (cheader_filename = "Bullet-C-Api.h")]
	public static double NearestPoints (float[] p1, float[] p2, float[] p3, float[] q1, float[] q2, float[] q3, float pa, float pb, float[] normal);
	[CCode (cheader_filename = "Bullet-C-Api.h")]
	public static unowned Pl.CollisionBroadphase SapBroadphase_new (Pl.btBroadphaseCallback beginCallback, Pl.btBroadphaseCallback endCallback);
	[CCode (cheader_filename = "Bullet-C-Api.h")]
	public static void SetEuler (Pl.Real yaw, Pl.Real pitch, Pl.Real roll, Pl.Quaternion orient);
}
