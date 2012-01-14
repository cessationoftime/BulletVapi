// project created on 5/13/2009 at 6:54 PM
using GLib;
//using SDL;
//using SDLGraphics;
//using Gtk;
//using Gdk;

using GL; 
using GLUT;
using GLU;
using Math;

using Pl;

namespace Bullet.Demos.Dino {
	class Demo {
	static const int X = 0;
	static const int Y = 1;
	static const int Z = 2;
	static const int W = 3;
	static const int A = 0;
	static const int B = 1;
	static const int C = 2;
	static const int D = 3;
	
	
	const float f_PI = 3.14159265f;
	
	static PhysicsSdk phys;
	static DynamicsWorld dynamicsWorld;
	static RigidBody floorRigidBody;
	static RigidBody dinoRigidBody;
	
	/* Variable controlling various rendering modes. */
	static bool stencilReflection  = true;static bool stencilShadow  = true;static bool offsetShadow = true;
	static bool renderShadow = true; static bool renderDinosaur = true;static bool renderReflection = true;
	static bool linearFiltering = false; static bool useMipmaps = false; static bool useTexture = true;
	static bool reportSpeed = false;
	static bool animation = true;
	static GLboolean lightSwitch = (GLboolean)true;
	static bool directionalLight = true;
	static bool forceExtension = false;
	
	/* Time varying or user-controled variables. */
	static float jump = 0.0f;
	static float lightAngle = 0.0f;
	static float lightHeight = 20f;
	static GLfloat angle = -150;   // in degrees
	static GLfloat angle2 = 30;  // in degrees
	
	static bool moving = false; static int startx = 0; static int starty = 0;
	static bool lightMoving = false; static int lightStartX = 0; static int lightStartY = 0;
	
	enum AnEnum {
	  MISSING, EXTENSION, ONE_DOT_ONE
	}
	static int polygonOffsetVersion;
	
	const GLdouble bodyWidth = 3.0;
	/* *INDENT-OFF* */
	  
	static GLfloat[] lightPosition = new GLfloat[4];
	static const GLfloat[] lightColor = {0.8f, 1.0f, 0.8f, 1.0f}; // green-tinted 
	static const GLfloat[] skinColor = {0.1f, 1.0f, 0.1f, 1.0f};
	static const GLfloat[] eyeColor = {1.0f, 0.2f, 0.2f, 1.0f};
	
	static GLfloat[] floorPlane;
	static GLfloat[] floorShadow;
	
	/* *INDENT-ON* */
	
	/* Nice floor texture tiling pattern. */
	static string[] circles = {
	  "....xxxx........",
	  "..xxxxxxxx......",
	  ".xxxxxxxxxx.....",
	  ".xxx....xxx.....",
	  "xxx......xxx....",
	  "xxx......xxx....",
	  "xxx......xxx....",
	  "xxx......xxx....",
	  ".xxx....xxx.....",
	  ".xxxxxxxxxx.....",
	  "..xxxxxxxx......",
	  "....xxxx........",
	  "................",
	  "................",
	  "................",
	  "................"
	};
	
	public int output;
	
	///////////////////////////////////////////
	//Stacked (Jagged) arrays are not implemented in Vala as of yet (0.11.2).  Therefore we will be using pointers in their place.
	GLfloat** body;
	GLfloat** eye;
	GLfloat** leg;
	GLfloat** arm;
	GLfloat** floorVertices;
	
	public Demo(string[] args) {
		
		floorVertices = StackedArrays.getFloorVertices();
		body = StackedArrays.getDinoBody();
		eye = StackedArrays.getDinoEye();
		leg = StackedArrays.getDinoLeg();
		arm = StackedArrays.getDinoArm();
		
		
		//for (int i=0;i<4;i++)
		//{
//			stdout.printf("Vertex %i: %f %f %f\n",i,(float)floorVertices[i][0],(float)floorVertices[i][1],(float)floorVertices[i][2]);
	//	}
		 
		int i;
		ConvexHullShape floorShape;
		BoxShape dinoChildShape;
		CompoundShape dinoShape;
		Vector3 floorPos = new Vector3.xyz(0,0,0);
		Vector3 childPos;
		Vector3 dinoPos;
		Quaternion childOrn;
		Quaternion dinoOrient = new Quaternion();
		
		void* user_data=null;
		
		phys = new PhysicsSdk();
		dynamicsWorld = new DynamicsWorld(phys);
	
	//----------------------------------------------
	    floorShape = new ConvexHullShape();
		for (i=0;i<4;i++)
		{
			floorShape.AddVertex((Real)floorVertices[i][0],(Real)floorVertices[i][1],(Real)floorVertices[i][2]);
		}
		
		
		//I dont know why we overwrite floorShape with BoxShape, it seems to work as just ConvexHull with AddVertex,
		//I am guessing this demonstrates two ways to build the floor
		floorShape = (ConvexHullShape)new BoxShape((Real)120f,(Real)0f,(Real)120f);
		//--------------------------------------------
		
		floorRigidBody = new RigidBody(user_data,0f,floorShape);

	
		floorRigidBody.SetPosition(floorPos);
		dynamicsWorld.AddRigidBody(floorRigidBody);
		
		//create dino rigidbody
		dinoChildShape = new BoxShape((Real)8.5f,(Real)8.5f,(Real)8.5f);
		dinoShape = new CompoundShape();
		childPos = new Vector3.xyz(0,0,0);
		childOrn = new Quaternion.xyzw(0,0,0,1);
	
		dinoShape.AddChildShape(dinoChildShape,childPos,childOrn);
		
		void* dino_data=null;
		
		dinoPos = new Vector3.xyz(-10,28,0);
		
		dinoRigidBody = new RigidBody(dino_data,1.0f,dinoShape);
		dinoRigidBody.SetPosition(dinoPos);
		
		SetEuler((Real)0f,(Real)0f,(Real)(3.15f*0.20f),dinoOrient);
		
		dinoRigidBody.SetOrientation(dinoOrient);
	
		dynamicsWorld.AddRigidBody(dinoRigidBody);
	
		 stdout.printf("BulletDino\n");
	  
	glutInit(ref args.length, args);
	
	  foreach (string arg in args) {
	    if ("-linear" != arg) {
	      linearFiltering = true;
	    } else if ("-mipmap" != arg) {
	      useMipmaps = true;
	    } else if ("-ext" != arg) {
	      forceExtension = true;
	    }
	  }
	
	  glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH | GLUT_STENCIL | GLUT_MULTISAMPLE);
	
	#if 0
	  // In GLUT 4.0, youll be able to do this an be sure to
	   // get 2 bits of stencil if the machine has it for you. 
	  glutInitDisplayString("samples stencil>=2 rgb double depth");
	 // glutInitDisplayString("samples rgb double depth");
	#endif
	
	  glutCreateWindow("Shadowy Leapin' Lizards");
	
	 if (glutGet(GLUT_WINDOW_STENCIL_SIZE) <= 1) {
	    stdout.printf("dinoshade: Sorry, I need at least 2 bits of stencil.\n");
	    output=1;
	    return;
	  }
	
	
	 // Register GLUT callbacks. 
	 glutDisplayFunc(redraw);
	 glutMouseFunc(mouse);
	  glutMotionFunc(motion);
	  glutVisibilityFunc(visible);
	  glutKeyboardFunc(key);
	  glutSpecialFunc(special);
	
	  glutCreateMenu(controlLights);
	
	  glutAddMenuEntry("Toggle motion", M.MOTION);
	  glutAddMenuEntry("-----------------------", M.NONE);
	  glutAddMenuEntry("Toggle light", M.LIGHT);
	  glutAddMenuEntry("Toggle texture", M.TEXTURE);
	  glutAddMenuEntry("Toggle shadows", M.SHADOWS);
	  glutAddMenuEntry("Toggle reflection", M.REFLECTION);
	  glutAddMenuEntry("Toggle dinosaur", M.DINOSAUR);
	  glutAddMenuEntry("-----------------------", M.NONE);
	  glutAddMenuEntry("Toggle reflection stenciling", M.STENCIL_REFLECTION);
	  glutAddMenuEntry("Toggle shadow stenciling", M.STENCIL_SHADOW);
	  glutAddMenuEntry("Toggle shadow offset", M.OFFSET_SHADOW);
	  glutAddMenuEntry("----------------------", M.NONE);
	  glutAddMenuEntry("Positional light", M.POSITIONAL);
	  glutAddMenuEntry("Directional light", M.DIRECTIONAL);
	  glutAddMenuEntry("-----------------------", M.NONE);
	  glutAddMenuEntry("Toggle performance", M.PERFORMANCE);
	  glutAttachMenu(GLUT_RIGHT_BUTTON);
	  
	  
	   makeDinosaur();
	
	//#if GL_VERSION_1_1
	  if (supportsOneDotOne() && !forceExtension) {
	    polygonOffsetVersion = AnEnum.ONE_DOT_ONE;
	    glPolygonOffset(-2.0f, -1.0f);
	  } else
	//#endif
	  {
	    {
	      polygonOffsetVersion = AnEnum.MISSING;
	      stdout.printf("\ndinoshine: Missing polygon offset.\n");
	     stdout.printf("           Expect shadow depth aliasing artifacts.\n\n");
	    }
	  }
	
	  glEnable(GL_CULL_FACE);
	  glEnable(GL_DEPTH_TEST);
	  glEnable(GL_TEXTURE_2D);
	  glLineWidth(3.0f);
	
	  glMatrixMode(GL_PROJECTION);
	  gluPerspective( // field of view in degree
	   40.0,
	  // aspect ratio 
	  1.0,
	    // Z near  
	    20.0, 
	    // Z far 
	     100.0);
	  glMatrixMode(GL_MODELVIEW);
	  gluLookAt(0.0, 8.0, 60.0,  // eye is at (0,0,30) 
	    0.0, 8.0, 0.0,      // center is at (0,0,0) 
	    0.0, 1.0, 0.0);      // up is in postivie Y direction
	
	  glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER, 1);
	  glLightfv(GL_LIGHT0, GL_DIFFUSE, lightColor);
	  glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0.1f);
	  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 0.05f);
	  glEnable(GL_LIGHT0);
	  glEnable(GL_LIGHTING);
	
	 makeFloorTexture();
	
	  // Setup floor plane for projected shadow calculations.
	  floorPlane= findPlane(floorVertices[1], floorVertices[2], floorVertices[3]);
	
	  glutMainLoop();
	  
	  StackedArrays.teardownDinoBodyArrays(body,leg,arm,eye);
	  StackedArrays.deleteStackedArray(floorVertices,4);
	  //StackedArrays.deleteStackedArray(floorShadow,4);
	  output=0;
	  
	}
	
	///////////////////////////////////////////
	static void makeFloorTexture()
	{
		
	    GLubyte[,,] floorTexture = new GLubyte[16,16,3];
	 
	  
	  GLubyte *loc;
	  int s, t;
	  loc=null;
	
	
	  // Setup RGB image for the texture. 
	   loc = (GLubyte*) floorTexture;
	  for (t = 0; t < 16; t++) {
		//  loca = (GLubyte**) floorTexture[t];
	    for (s = 0; s < 16; s++) {
	      if (circles[t][s] == 'x') {
		// Nice green. 
	        loc[0] = 0x1f;  loc[1] = 0x8f;  loc[2] = 0x1f;
	      } else {
		// Light gray. 
	        loc[0] = 0xaa;  loc[1] = 0xaa;  loc[2] = 0xaa;
	      }
	      loc += 3;
	    }
	  }
	
	  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
	
	  if (useMipmaps) {
	    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
	    gluBuild2DMipmaps(GL_TEXTURE_2D, 3, 16, 16, GL_RGB, GL_UNSIGNED_BYTE, floorTexture);
	  } else {
	    if (linearFiltering) {
	      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	    } else {
	      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	    }
	    glTexImage2D(GL_TEXTURE_2D, 0, 3, 16, 16, 0, GL_RGB, GL_UNSIGNED_BYTE, floorTexture);
	  }
	  
	}
	
	
	
	
	/* Find the plane equation given 3 points. */
	GLfloat[] findPlane(GLfloat* v0, GLfloat* v1, GLfloat* v2)
	{
		GLfloat[] plane = new GLfloat[4];
		
		
	  GLfloat[] vec0 = new GLfloat[3];
	  GLfloat[] vec1 = new GLfloat[3];
	
	  // Need 2 vectors to find cross product. 
	  vec0[X] = v1[X] - v0[X];
	  vec0[Y] = v1[Y] - v0[Y];
	  vec0[Z] = v1[Z] - v0[Z];
	
	  vec1[X] = v2[X] - v0[X];
	  vec1[Y] = v2[Y] - v0[Y];
	  vec1[Z] = v2[Z] - v0[Z];
	
	  // find cross product to get A, B, and C of plane equation
	  plane[A] = vec0[Y] * vec1[Z] - vec0[Z] * vec1[Y];
	  plane[B] = -(vec0[X] * vec1[Z] - vec0[Z] * vec1[X]);
	  plane[C] = vec0[X] * vec1[Y] - vec0[Y] * vec1[X];
	
	  plane[D] = -(plane[A] * v0[X] + plane[B] * v0[Y] + plane[C] * v0[Z]);
	  
	  return plane;
	}
	
	
	void extrudeSolidFromPolygon(GLfloat** data, ulong count, GLdouble thickness, GLuint side, GLuint edge, GLuint whole)
	{
		Tesselator tobj = null;
	  GLdouble[] vertex = new GLdouble[3];
	  GLdouble dx, dy, len;
	
	  int i;
	 // ulong si = 2 * sizeof(GLfloat);
	//  ulong count = dataSize / si;
	 // ulong count = dataSize / sizeof(GLfloat);
	//ulong count = dataSize;
	  if (tobj == null) {
	    tobj = new Tesselator(); //  create and initialize a GLU
	                            // polygon * * tesselation object 
	    tobj.TessCallback((GLenum)GLU_BEGIN, (GLUfuncptr)glBegin);
	    tobj.TessCallback((GLenum)GLU_VERTEX,(GLUfuncptr)glVertex2fv);   //semi-tricky 
	    tobj.TessCallback((GLenum)GLU_END, glEnd);
	  }
	  glNewList(side, GL_COMPILE);
	  glShadeModel(GL_SMOOTH); // smooth minimizes seeing
	                           //    tessellation 
	  tobj.BeginPolygon();
	  for (i = 0; i < count; i++) {
	    vertex[0] = data[i][0];
	    vertex[1] = data[i][1];
	    vertex[2] = 0;
	    tobj.TessVertex(vertex, (GLvoid*)data[i]);
	  }
	  tobj.EndPolygon();
	  glEndList();
	  glNewList(edge, GL_COMPILE);
	  glShadeModel(GL_FLAT);  // flat shade keeps angular hands
	                            // from being "smoothed"
	  glBegin(GL_QUAD_STRIP);
	  for (i = 0; i <= count; i++) {
	    // mod function handles closing the edge
	    glVertex3f(data[i % count][0], data[i % count][1], 0.0f);
	    glVertex3f(data[i % count][0], data[i % count][1], (GLfloat)thickness);
	    // Calculate a unit normal by dividing by Euclidean
	     //  distance. We * could be lazy and use
	    //   glEnable(GL_NORMALIZE) so we could pass in * arbitrary
	    //   normals for a very slight performance hit.
	    dx = data[(i + 1) % count][1] - data[i % count][1];
	    dy = data[i % count][0] - data[(i + 1) % count][0];
	    len = sqrt(dx * dx + dy * dy);
	    glNormal3f((GLfloat)(dx / len),(GLfloat)(dy / len), 0.0f);
	  }
	  glEnd();
	  glEndList();
	  glNewList(whole, GL_COMPILE);
	  glFrontFace(GL_CW);
	  glCallList(edge);
	  glNormal3f(0.0f, 0.0f, -1.0f);  // constant normal for side 
	  glCallList(side);
	  glPushMatrix();
	  glTranslatef(0.0f, 0.0f, (GLfloat)thickness);
	  glFrontFace(GL_CCW);
	  glNormal3f(0.0f, 0.0f, 1.0f);  // opposite normal for other side //
	  glCallList(side);
	  glPopMatrix();
	  glEndList();
	  
	}
	
	// Enumerants for refering to display lists.
	enum displayLists {
	  RESERVED, BODY_SIDE, BODY_EDGE, BODY_WHOLE, ARM_SIDE, ARM_EDGE, ARM_WHOLE,
	  LEG_SIDE, LEG_EDGE, LEG_WHOLE, EYE_SIDE, EYE_EDGE, EYE_WHOLE
	}
	
	void makeDinosaur()
	{
	  extrudeSolidFromPolygon(body,22, bodyWidth,
	    displayLists.BODY_SIDE, displayLists.BODY_EDGE, displayLists.BODY_WHOLE);
	  extrudeSolidFromPolygon(arm, 16, bodyWidth / 4,
	   displayLists.ARM_SIDE, displayLists.ARM_EDGE, displayLists.ARM_WHOLE);
	  extrudeSolidFromPolygon(leg, 14, bodyWidth / 2,
	    displayLists.LEG_SIDE, displayLists.LEG_EDGE, displayLists.LEG_WHOLE);
	  extrudeSolidFromPolygon(eye, 6, bodyWidth + 0.2,
	    displayLists.EYE_SIDE, displayLists.EYE_EDGE, displayLists.EYE_WHOLE); 
	}
	
	
	static void drawDinosaur()
	{
	
		Real[] matrix = new Real[16];
	
		glPushMatrix();
	  // Translate the dinosaur to be at (0,8,0). 
	
		dinoRigidBody.GetOpenGLMatrix(matrix);
	//	dinoRigidBody.GetPosition(dinoWorldPos);
	 // glTranslatef(-8, 0, -bodyWidth / 2);
	  //glTranslatef(0.0, jump, 0.0);
	//	glTranslatef(dinoWorldPos[0],dinoWorldPos[1],dinoWorldPos[2]);
	
	#if BT_USE_DOUBLE_PRECISION
		glMultMatrixd(matrix);
	#else
		glMultMatrixf((GLfloat[])matrix);
	#endif
	//	glutSolidCube(15);
		glTranslatef(-8.5f, -8.5f, 0f);
	
	  glMaterialfv(GL_FRONT, GL_DIFFUSE, skinColor);
	  glCallList(displayLists.BODY_WHOLE);
	  glTranslatef(0.0f, 0.0f, (GLfloat)bodyWidth);
	  glCallList(displayLists.ARM_WHOLE);
	  glCallList(displayLists.LEG_WHOLE);
	  glTranslatef(0.0f, 0.0f, (GLfloat)(-bodyWidth - bodyWidth / 4));
	  glCallList(displayLists.ARM_WHOLE);
	  glTranslatef(0.0f, 0.0f, (GLfloat)(-bodyWidth / 4));
	  glCallList(displayLists.LEG_WHOLE);
	  glTranslatef(0.0f, 0.0f,(GLfloat)(bodyWidth / 2 - 0.1f));
	  glMaterialfv(GL_FRONT, GL_DIFFUSE, eyeColor);
	  glCallList(displayLists.EYE_WHOLE);
	  
		
	  glPopMatrix();
	  
	}
	
	
	

	//VALA BUG!!!!! -- if floorVertices is an instance variable and the function drawFloor is static,
	//then the error message says that floorVertices does not denote an array...which it sortof does (floorVertices is declared as GLfloat**)
	// but the real problem is the static function cannot access it, not that it is not an array
	// Draw a floor (possibly textured). 
	static void drawFloor()
	{
		
	  glDisable(GL_LIGHTING);
	
	  if (useTexture) {
	    glEnable(GL_TEXTURE_2D);
	  }
	  GLfloat** floorVertices = StackedArrays.getFloorVertices();
	
	  glBegin(GL_QUADS);
	    glTexCoord2f(0.0f, 0.0f);
	    glVertex3fv((GLfloat[])floorVertices[0]);
	    glTexCoord2f(0.0f, 16.0f);
	    glVertex3fv((GLfloat[])floorVertices[1]);
	    glTexCoord2f(16.0f, 16.0f);
	    glVertex3fv((GLfloat[])floorVertices[2]);
	    glTexCoord2f(16.0f, 0.0f);
	    glVertex3fv((GLfloat[])floorVertices[3]);
	  glEnd();
	  
	 StackedArrays.deleteStackedArray(floorVertices,4);
	 
	  if (useTexture) {
	    glDisable(GL_TEXTURE_2D);
	  }
	
	  glEnable(GL_LIGHTING);
	  
	  
	}
	
	

	 
	public static void redraw()
	{
	// Check for GL error codes.
	// GLenum err;
	//do {
	//err = glGetError();
	//stdout.printf("ErrorCode: %u \n", err);
	//} 
	//while (err != GL_NO_ERROR); 
		
	  int start = 0, end = 0 ;
	
	  if (reportSpeed) {
	    start = glutGet(GLUT_ELAPSED_TIME);
	  }
	
	 // Clear; default stencil clears to zero. 
	  if ((stencilReflection && renderReflection) || (stencilShadow && renderShadow)) {
	    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
	  } else {
	   //  Avoid clearing stencil when not using it. 
	    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	  }
	
	  // Reposition the light source. 
	  lightPosition[0] = 12*cosf(lightAngle);
	  lightPosition[1] = lightHeight;
	  lightPosition[2] = 12*sinf(lightAngle);
	  if (directionalLight) {
	    lightPosition[3] = 0.0f;
	  } else {
	    lightPosition[3] = 1.0f;
	  }
	
	
    	floorShadow = StackedArrays.getShadowMatrix(floorPlane, lightPosition);
		
	  	glPushMatrix();
	    // Perform scene rotations based on user mouse input. 
	    glRotatef(angle2, 1.0f, 0.0f, 0.0f);
	    glRotatef(angle, 0.0f, 1.0f, 0.0f);
	     
	    //Tell GL new light source position.
	    glLightfv(GL_LIGHT0, GL_POSITION, lightPosition);
	
	    if (renderReflection) {
	      if (stencilReflection) {
	        //We can eliminate the visual "artifact" of seeing the "flipped"
	  	    //dinosaur underneath the floor by using stencil.  The idea is
		    //draw the floor without color or depth update but so that 
		    //a stencil value of one is where the floor will be.  Later when
		   //rendering the dinosaur reflection, we will only update pixels
		   //with a stencil value of 1 to make sure the reflection only
		   //lives on the floor, not below the floor.
	
	        // Dont update color or depth.
	        glDisable(GL_DEPTH_TEST);
	        glColorMask((GLboolean)false, (GLboolean)false, (GLboolean)false,(GLboolean) false);
	
	        // Draw 1 into the stencil buffer. 
	        glEnable(GL_STENCIL_TEST);
	        glStencilOp(GL_REPLACE, GL_REPLACE, GL_REPLACE);
	        glStencilFunc(GL_ALWAYS, 1, (GLuint)0xffffffff);
	
	        // Now render floor; floor pixels just get their stencil set to 1.
	        drawFloor();
	
	        // Re-enable update of color and depth. 
	        glColorMask((GLboolean)true,(GLboolean) true,(GLboolean) true,(GLboolean) true);
	        glEnable(GL_DEPTH_TEST);
	
	        // Now, only render where stencil is set to 1. 
	        glStencilFunc(GL_EQUAL, 1, (GLuint)0xffffffff);  // draw if ==1 
	        glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);
	      }
	
	      glPushMatrix();
	
	        // The critical reflection step: Reflect dinosaur through the floor
	         //  (the Y=0 plane) to make a relection. 
	        glScalef(1.0f, -1.0f, 1.0f);
	
		// Reflect the light position.
	        glLightfv(GL_LIGHT0, GL_POSITION, lightPosition);
	
	        // To avoid our normals getting reversed and hence botched lighting
		   //on the reflection, turn on normalize.  
	        glEnable(GL_NORMALIZE);
	        glCullFace(GL_FRONT);
	
	        // Draw the reflected dinosaur.
	        drawDinosaur();
	
	        // Disable noramlize again and re-enable back face culling. 
	        glDisable(GL_NORMALIZE);
	        glCullFace(GL_BACK);
	
	      glPopMatrix();
	
	      // Switch back to the unreflected light position.
	      glLightfv(GL_LIGHT0, GL_POSITION, lightPosition);
	
	      if (stencilReflection) {
	        glDisable(GL_STENCIL_TEST);
	      }
	    }
	
	    // Back face culling will get used to only draw either the top or the
	     //  bottom floor.  This lets us get a floor with two distinct
	     //  appearances.  The top floor surface is reflective and kind of red.
	      // The bottom floor surface is not reflective and blue. 
	
	    // Draw "bottom" of floor in blue.
	    glFrontFace(GL_CW);  //Switch face orientation.
	    glColor4f(0.1f, 0.1f, 0.7f, 1.0f);
	    drawFloor();
	    glFrontFace(GL_CCW);
	
	
	    if (renderShadow) {
	      if (stencilShadow) {
		///Draw the floor with stencil value 3.  This helps us only 
		   //draw the shadow once per floor pixel (and only on the
		  // floor pixels).
	        glEnable(GL_STENCIL_TEST);
	        glStencilFunc(GL_ALWAYS, 3, (GLuint)0xffffffff);
	        glStencilOp(GL_KEEP, GL_KEEP, GL_REPLACE);
	      }
	    }
	
	     //Draw "top" of floor.  Use blending to blend in reflection. 
	    glEnable(GL_BLEND);
	    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	    glColor4f(0.7f, 0.0f, 0.0f, 0.3f);
	    glColor4f(1.0f, 1.0f, 1.0f, 0.3f);
	    drawFloor();
	    glDisable(GL_BLEND);
	
	    if (renderDinosaur) {
	      // Draw "actual" dinosaur, not its reflection.
	      drawDinosaur();
	    }
	
	    if (renderShadow) {
	
	      // Render the projected shadow.
	
	      if (stencilShadow) {
	
	        // Now, only render where stencil is set above 2 (ie, 3 where
		   //the top floor is).  Update stencil with 2 where the shadow
		   //gets drawn so we dont redraw (and accidently reblend) the
		   //shadow).
	        glStencilFunc(GL_LESS, 2, (GLuint)0xffffffff);  // draw if ==1
	        glStencilOp(GL_REPLACE, GL_REPLACE, GL_REPLACE);
	      }
	
	      // To eliminate depth buffer artifacts, we use polygon offset
		 //to raise the depth of the projected shadow slightly so
		// that it does not depth buffer alias with the floor.
	      if (offsetShadow) {
		switch (polygonOffsetVersion) {
		case AnEnum.EXTENSION:
	//#ifdef GL_VERSION_1_1
		case AnEnum.ONE_DOT_ONE:
	          glEnable(GL_POLYGON_OFFSET_FILL);
		  break;
	//#endif
		  case AnEnum.MISSING:
		  break;
		}
	      }
	
	      // Render 50% black shadow color on top of whatever the
	        // floor appareance is.
	      glEnable(GL_BLEND);
	      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	      glDisable(GL_LIGHTING);  // Force the 50% black.
	      glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
	
	      glPushMatrix();
		// Project the shadow.
	        glMultMatrixf((GLfloat[])floorShadow); 
	        drawDinosaur();
	      glPopMatrix();
	
	      glDisable(GL_BLEND);
	      glEnable(GL_LIGHTING);
	
	      if (offsetShadow) {
		switch (polygonOffsetVersion) {
	//#ifdef GL_VERSION_1_1
		case AnEnum.ONE_DOT_ONE:
	          glDisable(GL_POLYGON_OFFSET_FILL);
		  break;
	//#endif
		case AnEnum.MISSING:
		  break;
		}
	      }
	      if (stencilShadow) {
	        glDisable(GL_STENCIL_TEST);
	      }
	    }
	
	    glPushMatrix();
	    glDisable(GL_LIGHTING);
	    glColor3f(1.0f, 1.0f, 0.0f);
	    if (directionalLight) {
	       //Draw an arrowhead.
	      glDisable(GL_CULL_FACE);
	      glTranslatef(lightPosition[0], lightPosition[1], lightPosition[2]);
	      glRotatef(lightAngle * -180.0f / f_PI, 0, 1, 0);
	      glRotatef(atanf(lightHeight/12) * 180.0f / f_PI, 0, 0, 1);
	      glBegin(GL_TRIANGLE_FAN);
		glVertex3f(0f, 0f, 0f);
		glVertex3f(2f, 1f, 1f);
		glVertex3f(2f, -1f, 1f);
		glVertex3f(2f, -1f, -1f);
		glVertex3f(2f, 1f, -1f);
		glVertex3f(2f, 1f, 1f);
	      glEnd();
	      //Draw a white line from light direction.
	      glColor3f(1.0f, 1.0f, 1.0f);
	      glBegin(GL_LINES);
		glVertex3f(0f, 0f, 0f);
		glVertex3f(5f, 0f, 0f);
	      glEnd();
	      glEnable(GL_CULL_FACE);
	    } else {
	      // Draw a yellow ball at the light source
	      glTranslatef(lightPosition[0], lightPosition[1], lightPosition[2]);
	      glutSolidSphere(1.0, 5, 5);
	    }
	    glEnable(GL_LIGHTING);
	    glPopMatrix();
	
	  glPopMatrix();
	
	  if (reportSpeed) {
	    glFinish();
	    end = glutGet(GLUT_ELAPSED_TIME);
	    stdout.printf("Speed %.3g frames/sec (%d ms)\n", 1000.0/(end-start), end-start);
	  }
	
	  glutSwapBuffers();
	  
	}
	
	
	
	// ARGSUSED2 
	static void mouse(int button, int state, int x, int y)
	{
		
	  if (button == GLUT_LEFT_BUTTON) {
	    if (state == GLUT_DOWN) {
	      moving = true;
	      startx = x;
	      starty = y;
	    }
	    if (state == GLUT_UP) {
	      moving = false;
	    }
	  }
	  if (button == GLUT_MIDDLE_BUTTON) {
	    if (state == GLUT_DOWN) {
	      lightMoving = true;
	      lightStartX = x;
	      lightStartY = y;
	    }
	    if (state == GLUT_UP) {
	      lightMoving = false;
	    }
	  }
	  
	}
	
	// ARGSUSED1
	//public static delegate void on_glutMotionFunc (int _val1, int _val2);
	static void motion(int x, int y)
	{
		
	  if (moving) {
	    angle += (x - startx);
	    angle2 += (y - starty);
	    startx = x;
	    starty = y;
	    glutPostRedisplay();
	  }
	 /* if (lightMoving){//lightMoving) {
	    lightAngle += (x - lightStartX)/40.0f;
	    lightHeight += (lightStartY - y)/20.0f;
	    lightStartX = x;
	    lightStartY = y;
	    glutPostRedisplay();
  		} 
  		*/
	}
	
	// Advance time varying state when idle callback registered.
	static float time = 0.0f;
	static float prevtime = 0.0f;
	static void idle()
	{  
		
	  float dtime;
	  prevtime = time;
	
	  time = glutGet(GLUT_ELAPSED_TIME) / 500.0f;
	  dtime = time - prevtime;
	
	  jump = (float)(4.0 * fabs(Math.sinf(time)*0.5));
	  if (!lightMoving) {
	    lightAngle = time;
	  }
	
	  if (dynamicsWorld != null)
			dynamicsWorld.StepSimulation((Real)dtime);
	  
	  glutPostRedisplay();
	  
	}
	
	enum M {
	  NONE, MOTION, LIGHT, TEXTURE, SHADOWS, REFLECTION, DINOSAUR,
	  STENCIL_REFLECTION, STENCIL_SHADOW, OFFSET_SHADOW,
	  POSITIONAL, DIRECTIONAL, PERFORMANCE
	}
	
	static void controlLights(int value)
	{
		
	  switch (value) {
	  case M.NONE:
	    return;
	  case M.MOTION:
	    animation = animation ? false : true;
	    if (animation) {
	      glutIdleFunc(idle);
	    } else {
	      glutIdleFunc(null);
	    }
	    break;
	  case M.LIGHT:
	    lightSwitch = !lightSwitch;
	    if ((bool)lightSwitch) {
	      glEnable(GL_LIGHT0);
	    } else {
	      glDisable(GL_LIGHT0);
	    }
	    break;
	  case M.TEXTURE:
	    useTexture = !useTexture;
	    break;
	  case M.SHADOWS:
	    renderShadow = renderShadow ? false : true;
	    break;
	  case M.REFLECTION:
	    renderReflection = renderReflection ? false : true;
	    break;
	  case M.DINOSAUR:
	    renderDinosaur = renderDinosaur ? false : true;
	    break;
	  case M.STENCIL_REFLECTION:
	    stencilReflection = stencilReflection ? false : true;
	    break;
	  case M.STENCIL_SHADOW:
	    stencilShadow = stencilShadow ? false : true;
	    break;
	  case M.OFFSET_SHADOW:
	    offsetShadow = offsetShadow ? false : true;
	    break;
	  case M.POSITIONAL:
	    directionalLight = false;
	    break;
	  case M.DIRECTIONAL:
	    directionalLight = true;
	    break;
	  case M.PERFORMANCE:
	    reportSpeed = reportSpeed ? false : true;
	    break;
	    
	  }
	  glutPostRedisplay();
	  
	}
	
	// When not visible, stop animating.  Restart when visible again.
	static void visible(int vis)
	{
	  if (vis == GLUT_VISIBLE) {
	    if (animation) glutIdleFunc(idle);
	  } else {
	    if (!animation) glutIdleFunc(null);
	  }
	  
	}
	
	// Press any key to redraw; good when motion stopped and
	//   performance reporting on.
	// ARGSUSED
	static void key(uchar c, int x, int y)
	{
		
	  if (c == 27) {
	 //   exit(0);  // IRIS GLism, Escape quits.
	 return;
	  }
	  glutPostRedisplay();
	  
	}
	
	// Press any key to redraw; good when motion stopped and
	//   performance reporting on. 
	// ARGSUSED 
	static void special(int k, int x, int y)
	{
		
	  glutPostRedisplay();
	  
	}
	
	string version;
	bool supportsOneDotOne()
	{
		
	  
	  int major = 0;
	  int minor = 0;
	
	  version = glGetString(GL_VERSION);
	  if (version.scanf("%d.%d", &major, &minor) == 2)
	    return ((major > 1) || (major >= 1 && minor >= 1));
	    
	  return false;            // OpenGL version string malformed!
	  
	}
	
	
	
	}
	}


