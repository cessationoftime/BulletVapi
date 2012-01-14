using GLib;
//using SDL;
//using SDLGraphics;
//using Gtk;
//using Gdk;

using GL; 
using GLUT;
using GLU;
using Math;
using Memory;

using Pl;
	
namespace Bullet.Demos.Dino {
	
	///////////////////////////////////////////
	//Stacked (Jagged) arrays are not implemented in Vala as of yet (0.11.2).  Therefore I will be using pointers in their place.
public static class StackedArrays {
	static const int X = 0;
	static const int Y = 1;
	static const int Z = 2;
	static const int W = 3;
	static const int A = 0;
	static const int B = 1;
	static const int C = 2;
	static const int D = 3;
	
	public static GLfloat** getFloorVertices() {
		
		GLfloat** floorVertices = (GLfloat**)(malloc(4 * sizeof(GLfloat*)));
		        
	    for (int x=0;x<4;x++) {
		    floorVertices[x] = (GLfloat*)(malloc(3 * sizeof(GLfloat)));
		    floorVertices[x][1] =0.0f;
	    }
	    
	    floorVertices[0][0] =-20.0f;  floorVertices[0][2] = 20.0f;
	    floorVertices[1][0] = 20.0f;  floorVertices[1][2] = 20.0f; 
	    floorVertices[2][0] = 20.0f;  floorVertices[2][2] =-20.0f;
	    floorVertices[3][0] =-20.0f;  floorVertices[3][2] =-20.0f;
  
	    return floorVertices;
	}
	
	public static void deleteStackedArray(GLfloat** arr, int length) {
		for (int x=0;x<length;x++) {
		   delete arr[x];
	    }
	    delete arr;
	}
	
	public static GLfloat[] getShadowMatrix(GLfloat[] groundplane,  GLfloat[] lightpos)
	{
		//it seems that the vala vapi for glMultMatrixf is unable to support GLfloat** and vala itslf does not support Jagged 2D arrays, 
		//so in constrast to the C version of this demo we must use GLfloat[] instead
		GLfloat[] shadowMat = new GLfloat[16];
		
		GLfloat dot;
	
	  // Find dot product between light position vector and ground plane normal. 
	    dot = groundplane[X] * lightpos[X] +
	    groundplane[Y] * lightpos[Y] +
	    groundplane[Z] * lightpos[Z] +
	    groundplane[W] * lightpos[W];
	
		shadowMat[0] = dot - lightpos[X] * groundplane[X];
 		shadowMat[4] = 0f - lightpos[X] * groundplane[Y];
		shadowMat[8] = 0f - lightpos[X] * groundplane[Z];
	 	shadowMat[12] = 0f - lightpos[X] * groundplane[W];
	
	  	shadowMat[1] = 0f - lightpos[Y] * groundplane[X];
	  	shadowMat[5] = dot - lightpos[Y] * groundplane[Y];
	  	shadowMat[9] = 0f - lightpos[Y] * groundplane[Z];
	  	shadowMat[13] = 0f - lightpos[Y] * groundplane[W];
	
	  	shadowMat[2] = 0f - lightpos[Z] * groundplane[X];
	  	shadowMat[6] = 0f - lightpos[Z] * groundplane[Y];
	  	shadowMat[10] = dot - lightpos[Z] * groundplane[Z];
	  	shadowMat[14] = 0f - lightpos[Z] * groundplane[W];
	
	  	shadowMat[3] = 0f - lightpos[W] * groundplane[X];
	  	shadowMat[7] = 0f - lightpos[W] * groundplane[Y];
	  	shadowMat[11] = 0f - lightpos[W] * groundplane[Z];
	  	shadowMat[15] = dot - lightpos[W] * groundplane[W];
	
	return shadowMat;
	}
	
		static GLfloat** createJArrays(int x, int y) {
			GLfloat** F = (GLfloat**)malloc(x*sizeof(GLfloat*));
			
			for (int t = 0; t < x; t++) {	        
				F[t] = (GLfloat*)malloc(y*sizeof(GLfloat));
			}
			return F;
		}
	
		static void teardownJArrays(GLfloat** F, int length) {     
			for (int t = 0; t < length; t++) {	        
				delete F[t];
			}
			delete F;	
		}
	
	
	public static GLfloat** getDinoBody() {
		GLfloat** body = createJArrays(22,2);
		body[0][0] = 0f; 	body[0][1] = 3f;
		body[1][0] = 1f; 	body[1][1] = 1f;
		body[2][0] = 5f; 	body[2][1] = 1f;
		body[3][0] = 8f; 	body[3][1] = 4f;
		body[4][0] = 10f; 	body[4][1] = 4f;
		body[5][0] = 11f; 	body[5][1] = 5f;
		body[6][0] = 11f; 	body[6][1] = 11.5f;
		body[7][0] = 13f; 	body[7][1] = 12f;
		body[8][0] = 13f; 	body[8][1] = 13f;
		body[9][0] = 10f; 	body[9][1] = 13.5f;
		body[10][0] = 13f;	body[10][1] = 14f;
		body[11][0] = 13f; 	body[11][1] = 15f;
		body[12][0] = 11f; 	body[12][1] = 16f;
		body[13][0] = 8f; 	body[13][1] = 16f;
		body[14][0] = 7f; 	body[14][1] = 15f;
		body[15][0] = 7f; 	body[15][1] = 13f;
		body[16][0] = 8f; 	body[16][1] = 12f;
		body[17][0] = 7f; 	body[17][1] = 11f;
		body[18][0] = 6f; 	body[18][1] = 6f;
		body[19][0] = 4f; 	body[19][1] = 3f;
		body[20][0] = 3f; 	body[20][1] = 2f;
		body[21][0] = 1f; 	body[21][1] = 2f;
		
		return body;
	}
		
	public static GLfloat** getDinoEye() {
		GLfloat** eye = createJArrays(6,2);
		eye[0][0] = 8.75f;	eye[0][1] = 15f;
		eye[1][0] = 9f;		eye[1][1] = 14.7f;
		eye[2][0] = 9.6f;	eye[2][1] = 14.7f;
		eye[3][0] = 10.1f;	eye[3][1] = 15f;
		eye[4][0] = 9.6f;	eye[4][1] = 15.25f;
		eye[5][0] = 9f;		eye[5][1] = 15.25f;
		return eye;
	}
	public static GLfloat** getDinoLeg() {
		GLfloat** leg = createJArrays(14,2);
		leg[0][0] = 8f; 	leg[0][1] = 6f;
		leg[1][0] = 8f; 	leg[1][1] = 4f;
		leg[2][0] = 9f; 	leg[2][1] = 3f;
		leg[3][0] = 9f; 	leg[3][1] = 2f;
		leg[4][0] = 8f; 	leg[4][1] = 1f;
		leg[5][0] = 8f; 	leg[5][1] = 0.5f;
		leg[6][0] = 9f; 	leg[6][1] = 0f;
		leg[7][0] = 12f; 	leg[7][1] = 0f;
		leg[8][0] = 10f; 	leg[8][1] = 1f;
		leg[9][0] = 10f; 	leg[9][1] = 2f;
		leg[10][0] = 12f; 	leg[10][1] = 4f;
		leg[11][0] = 11f; 	leg[11][1] = 6f;
		leg[12][0] = 10f; 	leg[12][1] = 7f;
		leg[13][0] = 9f; 	leg[13][1] = 7f;
		return leg;
	}
	
	public static GLfloat** getDinoArm() {
		GLfloat** arm = createJArrays(16,2);
		arm[0][0] = 8f; 	arm[0][1] = 10f;
		arm[1][0] = 9f; 	arm[1][1] = 9f;
		arm[2][0] = 10f; 	arm[2][1] = 9f;
		arm[3][0] = 13f; 	arm[3][1] = 8f;
		arm[4][0] = 14f; 	arm[4][1] = 9f;
		arm[5][0] = 16f; 	arm[5][1] = 9f;
		arm[6][0] = 15f; 	arm[6][1] = 9.5f;
		arm[7][0] = 16f; 	arm[7][1] = 10f;
		arm[8][0] = 15f; 	arm[8][1] = 10f;
		arm[9][0] = 15.5f; 	arm[9][1] = 11f;
		arm[10][0] = 14.5f; arm[10][1] = 10f;
		arm[11][0] = 14f; 	arm[11][1] = 11f;
		arm[12][0] = 14f; 	arm[12][1] = 10f;
		arm[13][0] = 13f; 	arm[13][1] = 9f;
		arm[14][0] = 11f; 	arm[14][1] = 11f;
		arm[15][0] = 9f; 	arm[15][1] = 11f;
		return arm;
	}
	
	public static void teardownDinoBodyArrays(GLfloat** body,GLfloat** leg,GLfloat** arm,GLfloat** eye) {
		teardownJArrays(body,22);
		teardownJArrays(leg,14);
		teardownJArrays(arm,16);
		teardownJArrays(eye,6);
	}
	
}
}