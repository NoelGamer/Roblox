function MeshHandler.Polygonise(Mesh, Chunk, Grid, Position, Precision, Isolevel, Interpolate)
	local start = tick()
	local vertList = vertTable
	local cubeIndex = 1
	for i = 1, 8 do
		if Grid.Value[i] > Isolevel then
			cubeIndex += 2^(i - 1)
		end
	end
	if (edgeTable[cubeIndex] == 0) then return end
	if Interpolate then
		for i = 1, 12 do
			if (edgeTable[cubeIndex] and 2^(i - 1)) then
				vertList[i] = MeshHandler.Interpolate(Isolevel, Grid.Position[interpTable[1][i]], Grid.Position[interpTable[2][i]], Grid.Value[interpTable[1][i]], Grid.Value[interpTable[2][i]])
			end
		end
	end
	
	local triangletable = {}
	local nvert = 0
	while triTable[cubeIndex][nvert + 1] ~= -1 do
		local positions = {}
		for i = 1, 3 do
			 positions[4 - i] = Position + vertList[triTable[cubeIndex][nvert + i] + 1] * (Precision / 2)
		end
		
		local vertices = {}
		vertices = MeshHandler.ReuseVertices(Mesh, Chunk, Position, positions)
			
		local triangle = Mesh:AddTriangle(table.unpack(vertices))
		
		table.insert(triangletable, triangle)
		nvert += 3
	end
	MeshHandler.Times.Polygonise += tick() - start
	return triangletable
end

--[[
Original code from http://paulbourke.net/geometry/polygonise/

int Polygonise(GRIDCELL grid,double isolevel,TRIANGLE *triangles)
{
   int i,ntriang;
   int cubeindex;
   XYZ vertlist[12];
   /*
      Determine the index into the edge table which
      tells us which vertices are inside of the surface
   */
   cubeindex = 0;
   if (grid.val[0] < isolevel) cubeindex |= 1;
   if (grid.val[1] < isolevel) cubeindex |= 2;
   if (grid.val[2] < isolevel) cubeindex |= 4;
   if (grid.val[3] < isolevel) cubeindex |= 8;
   if (grid.val[4] < isolevel) cubeindex |= 16;
   if (grid.val[5] < isolevel) cubeindex |= 32;
   if (grid.val[6] < isolevel) cubeindex |= 64;
   if (grid.val[7] < isolevel) cubeindex |= 128;

   /* Cube is entirely in/out of the surface */
   if (edgeTable[cubeindex] == 0)
      return(0);

   /* Find the vertices where the surface intersects the cube */
   if (edgeTable[cubeindex] & 1)
      vertlist[0] =
         VertexInterp(isolevel,grid.p[0],grid.p[1],grid.val[0],grid.val[1]);
   if (edgeTable[cubeindex] & 2)
      vertlist[1] =
         VertexInterp(isolevel,grid.p[1],grid.p[2],grid.val[1],grid.val[2]);
   if (edgeTable[cubeindex] & 4)
      vertlist[2] =
         VertexInterp(isolevel,grid.p[2],grid.p[3],grid.val[2],grid.val[3]);
   if (edgeTable[cubeindex] & 8)
      vertlist[3] =
         VertexInterp(isolevel,grid.p[3],grid.p[0],grid.val[3],grid.val[0]);
   if (edgeTable[cubeindex] & 16)
      vertlist[4] =
         VertexInterp(isolevel,grid.p[4],grid.p[5],grid.val[4],grid.val[5]);
   if (edgeTable[cubeindex] & 32)
      vertlist[5] =
         VertexInterp(isolevel,grid.p[5],grid.p[6],grid.val[5],grid.val[6]);
   if (edgeTable[cubeindex] & 64)
      vertlist[6] =
         VertexInterp(isolevel,grid.p[6],grid.p[7],grid.val[6],grid.val[7]);
   if (edgeTable[cubeindex] & 128)
      vertlist[7] =
         VertexInterp(isolevel,grid.p[7],grid.p[4],grid.val[7],grid.val[4]);
   if (edgeTable[cubeindex] & 256)
      vertlist[8] =
         VertexInterp(isolevel,grid.p[0],grid.p[4],grid.val[0],grid.val[4]);
   if (edgeTable[cubeindex] & 512)
      vertlist[9] =
         VertexInterp(isolevel,grid.p[1],grid.p[5],grid.val[1],grid.val[5]);
   if (edgeTable[cubeindex] & 1024)
      vertlist[10] =
         VertexInterp(isolevel,grid.p[2],grid.p[6],grid.val[2],grid.val[6]);
   if (edgeTable[cubeindex] & 2048)
      vertlist[11] =
         VertexInterp(isolevel,grid.p[3],grid.p[7],grid.val[3],grid.val[7]);

   /* Create the triangle */
   ntriang = 0;
   for (i=0;triTable[cubeindex][i]!=-1;i+=3) {
      triangles[ntriang].p[0] = vertlist[triTable[cubeindex][i  ]];
      triangles[ntriang].p[1] = vertlist[triTable[cubeindex][i+1]];
      triangles[ntriang].p[2] = vertlist[triTable[cubeindex][i+2]];
      ntriang++;
   }
  
   return(ntriang);
}
]]
