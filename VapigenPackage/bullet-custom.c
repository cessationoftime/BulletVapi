
#include <glib.h>
#include <glib-object.h>
#include <gobject/gvaluecollector.h>


#define BULLET_TYPE_VECTOR_3 (bullet_vector_3_get_type ())
#define BULLET_VECTOR_3(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), BULLET_TYPE_VECTOR_3, BulletVector_3))
#define BULLET_VECTOR_3_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), BULLET_TYPE_VECTOR_3, BulletVector_3Class))
#define BULLET_IS_VECTOR_3(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), BULLET_TYPE_VECTOR_3))
#define BULLET_IS_VECTOR_3_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), BULLET_TYPE_VECTOR_3))
#define BULLET_VECTOR_3_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), BULLET_TYPE_VECTOR_3, BulletVector_3Class))

typedef struct _BulletVector_3 BulletVector_3;
typedef struct _BulletVector_3Class BulletVector_3Class;
typedef struct _BulletVector_3Private BulletVector_3Private;
typedef struct _BulletParamSpecVector_3 BulletParamSpecVector_3;

/*float*/
struct _BulletVector_3 {
	GTypeInstance parent_instance;
	volatile int ref_count;
	BulletVector_3Private * priv;
	float* Q;
	gint Q_length1;
};

struct _BulletVector_3Class {
	GTypeClass parent_class;
	void (*finalize) (BulletVector_3 *self);
};

struct _BulletParamSpecVector_3 {
	GParamSpec parent_instance;
};



gpointer bullet_vector_3_ref (gpointer instance);
void bullet_vector_3_unref (gpointer instance);
GParamSpec* bullet_param_spec_vector_3 (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void bullet_value_set_vector_3 (GValue* value, gpointer v_object);
gpointer bullet_value_get_vector_3 (const GValue* value);
GType bullet_vector_3_get_type (void);
enum  {
	BULLET_VECTOR_3_DUMMY_PROPERTY
};
BulletVector_3* bullet_vector_3_new (void);
BulletVector_3* bullet_vector_3_construct (GType object_type);
BulletVector_3* bullet_vector_3_new (void);
static float* _vala_array_dup1 (float* self, int length);
float* bullet_vector_3_CastToRealArray (BulletVector_3* vector, int* result_length1);
void bullet_vector_3_set_x (BulletVector_3* self, float value);
void bullet_vector_3_set_y (BulletVector_3* self, float value);
void bullet_vector_3_set_z (BulletVector_3* self, float value);
BulletVector_3* bullet_vector_3_CastFromRealArray (float* vector, int vector_length1);
float bullet_vector_3_get_x (BulletVector_3* self);
float bullet_vector_3_get_y (BulletVector_3* self);
float bullet_vector_3_get_z (BulletVector_3* self);
static gpointer bullet_vector_3_parent_class = NULL;
static void bullet_vector_3_finalize (BulletVector_3* obj);



GType bullet_real_get_type (void) {
	static GType bullet_real_type_id = 0;
	if (bullet_real_type_id == 0) {
		bullet_real_type_id = g_boxed_type_register_static ("float", (GBoxedCopyFunc) bullet_real_dup, (GBoxedFreeFunc) bullet_real_free);
	}
	return bullet_real_type_id;
}


/*[CCode (has_type_id = "pl_Vector3new")]*/
BulletVector_3* bullet_vector_3_construct (GType object_type) {
	BulletVector_3* self;
	float* _tmp0_;
	self = (BulletVector_3*) g_type_create_instance (object_type);
	_tmp0_ = NULL;
	self->Q = (_tmp0_ = g_new0 (float, 3), self->Q = (g_free (self->Q), NULL), self->Q_length1 = 3, _tmp0_);
	return self;
}


BulletVector_3* bullet_vector_3_new (void) {
	return bullet_vector_3_construct (BULLET_TYPE_VECTOR_3);
}


static float* _vala_array_dup1 (float* self, int length) {
	return g_memdup (self, length * sizeof (float));
}


/*This is used to cast from the Bullet.Vector_3 type and the Bullet.Real[] type.*/
float* bullet_vector_3_CastToRealArray (BulletVector_3* vector, int* result_length1) {
	float* _tmp0_;
	float* _tmp1_;
	_tmp0_ = NULL;
	_tmp1_ = NULL;
	return (_tmp1_ = (_tmp0_ = vector->Q, (_tmp0_ == NULL) ? ((gpointer) _tmp0_) : _vala_array_dup1 (_tmp0_, vector->Q_length1)), *result_length1 = vector->Q_length1, _tmp1_);
}


/*This is used to cast from the Bullet.Vector3 type and the Bullet.Real[] type.*/
BulletVector_3* bullet_vector_3_CastFromRealArray (float* vector, int vector_length1) {
	BulletVector_3* v;
	v = bullet_vector_3_new ();
	bullet_vector_3_set_x (v, vector[0]);
	bullet_vector_3_set_y (v, vector[1]);
	bullet_vector_3_set_z (v, vector[2]);
	return v;
}


float bullet_vector_3_get_x (BulletVector_3* self) {
	return self->Q[0];
}


void bullet_vector_3_set_x (BulletVector_3* self, float value) {
	g_return_if_fail (self != NULL);
	self->Q[0] = value;
}


float bullet_vector_3_get_y (BulletVector_3* self) {
	return self->Q[1];
}


void bullet_vector_3_set_y (BulletVector_3* self, float value) {
	g_return_if_fail (self != NULL);
	self->Q[1] = value;
}


float bullet_vector_3_get_z (BulletVector_3* self) {
	return self->Q[2];
}


void bullet_vector_3_set_z (BulletVector_3* self, float value) {
	g_return_if_fail (self != NULL);
	self->Q[2] = value;
}


static void bullet_value_vector_3_init (GValue* value) {
	value->data[0].v_pointer = NULL;
}


static void bullet_value_vector_3_free_value (GValue* value) {
	if (value->data[0].v_pointer) {
		bullet_vector_3_unref (value->data[0].v_pointer);
	}
}


static void bullet_value_vector_3_copy_value (const GValue* src_value, GValue* dest_value) {
	if (src_value->data[0].v_pointer) {
		dest_value->data[0].v_pointer = bullet_vector_3_ref (src_value->data[0].v_pointer);
	} else {
		dest_value->data[0].v_pointer = NULL;
	}
}


static gpointer bullet_value_vector_3_peek_pointer (const GValue* value) {
	return value->data[0].v_pointer;
}


static gchar* bullet_value_vector_3_collect_value (GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	if (collect_values[0].v_pointer) {
		BulletVector_3* object;
		object = collect_values[0].v_pointer;
		if (object->parent_instance.g_class == NULL) {
			return g_strconcat ("invalid unclassed object pointer for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
		} else if (!g_value_type_compatible (G_TYPE_FROM_INSTANCE (object), G_VALUE_TYPE (value))) {
			return g_strconcat ("invalid object type `", g_type_name (G_TYPE_FROM_INSTANCE (object)), "' for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
		}
		value->data[0].v_pointer = bullet_vector_3_ref (object);
	} else {
		value->data[0].v_pointer = NULL;
	}
	return NULL;
}


static gchar* bullet_value_vector_3_lcopy_value (const GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	BulletVector_3** object_p;
	object_p = collect_values[0].v_pointer;
	if (!object_p) {
		return g_strdup_printf ("value location for `%s' passed as NULL", G_VALUE_TYPE_NAME (value));
	}
	if (!value->data[0].v_pointer) {
		*object_p = NULL;
	} else if (collect_flags && G_VALUE_NOCOPY_CONTENTS) {
		*object_p = value->data[0].v_pointer;
	} else {
		*object_p = bullet_vector_3_ref (value->data[0].v_pointer);
	}
	return NULL;
}


GParamSpec* bullet_param_spec_vector_3 (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags) {
	BulletParamSpecVector_3* spec;
	g_return_val_if_fail (g_type_is_a (object_type, BULLET_TYPE_VECTOR_3), NULL);
	spec = g_param_spec_internal (G_TYPE_PARAM_OBJECT, name, nick, blurb, flags);
	G_PARAM_SPEC (spec)->value_type = object_type;
	return G_PARAM_SPEC (spec);
}


gpointer bullet_value_get_vector_3 (const GValue* value) {
	g_return_val_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, BULLET_TYPE_VECTOR_3), NULL);
	return value->data[0].v_pointer;
}


void bullet_value_set_vector_3 (GValue* value, gpointer v_object) {
	BulletVector_3* old;
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, BULLET_TYPE_VECTOR_3));
	old = value->data[0].v_pointer;
	if (v_object) {
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, BULLET_TYPE_VECTOR_3));
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
		value->data[0].v_pointer = v_object;
		bullet_vector_3_ref (value->data[0].v_pointer);
	} else {
		value->data[0].v_pointer = NULL;
	}
	if (old) {
		bullet_vector_3_unref (old);
	}
}


static void bullet_vector_3_class_init (BulletVector_3Class * klass) {
	bullet_vector_3_parent_class = g_type_class_peek_parent (klass);
	BULLET_VECTOR_3_CLASS (klass)->finalize = bullet_vector_3_finalize;
}


static void bullet_vector_3_instance_init (BulletVector_3 * self) {
	self->ref_count = 1;
}


static void bullet_vector_3_finalize (BulletVector_3* obj) {
	BulletVector_3 * self;
	self = BULLET_VECTOR_3 (obj);
	self->Q = (g_free (self->Q), NULL);
}


GType bullet_vector_3_get_type (void) {
	static GType bullet_vector_3_type_id = 0;
	if (bullet_vector_3_type_id == 0) {
		static const GTypeValueTable g_define_type_value_table = { bullet_value_vector_3_init, bullet_value_vector_3_free_value, bullet_value_vector_3_copy_value, bullet_value_vector_3_peek_pointer, "p", bullet_value_vector_3_collect_value, "p", bullet_value_vector_3_lcopy_value };
		static const GTypeInfo g_define_type_info = { sizeof (BulletVector_3Class), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) bullet_vector_3_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (BulletVector_3), 0, (GInstanceInitFunc) bullet_vector_3_instance_init, &g_define_type_value_table };
		static const GTypeFundamentalInfo g_define_type_fundamental_info = { (G_TYPE_FLAG_CLASSED | G_TYPE_FLAG_INSTANTIATABLE | G_TYPE_FLAG_DERIVABLE | G_TYPE_FLAG_DEEP_DERIVABLE) };
		bullet_vector_3_type_id = g_type_register_fundamental (g_type_fundamental_next (), "BulletVector_3", &g_define_type_info, &g_define_type_fundamental_info, 0);
	}
	return bullet_vector_3_type_id;
}


gpointer bullet_vector_3_ref (gpointer instance) {
	BulletVector_3* self;
	self = instance;
	g_atomic_int_inc (&self->ref_count);
	return instance;
}


void bullet_vector_3_unref (gpointer instance) {
	BulletVector_3* self;
	self = instance;
	if (g_atomic_int_dec_and_test (&self->ref_count)) {
		BULLET_VECTOR_3_GET_CLASS (self)->finalize (self);
		g_type_free_instance ((GTypeInstance *) self);
	}
}




