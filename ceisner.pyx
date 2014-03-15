# distutils: language = c++
from libcpp.utility cimport pair
from libcpp.list cimport list
from libcpp cimport bool
from libc.stdlib cimport malloc, calloc, free

cdef struct EisnerNode:
    int score
    list[pair[int, int]] edge_list
    
ctypedef EisnerNode* P_EisnerNode
    
cdef class EisnerParser:
    cdef P_EisnerNode ***e
    
    def __cinit__(self):
        pass
    
    def init_eisner_matrix(self, n):
        self.e = <P_EisnerNode***>malloc(n*sizeof(P_EisnerNode**))
        for i in range(n):
            self.e[i] = <P_EisnerNode**>malloc(n*sizeof(P_EisnerNode*))
            for j in range(n):
                self.e[i][j] = <P_EisnerNode*>malloc(2*sizeof(P_EisnerNode))
                for k in [0,1]:
                    self.e[i][j][k] = <P_EisnerNode>malloc(2*sizeof(EisnerNode))

        return
    """
    cdef add_list(self, EisnerNode& a, int scor):
        print "add_eisner_node"
        cdef EisnerNode c
        c.score = a.score + b.score

        a.edge_list.sort()
        b.edge_list.sort()
        c.edge_list.merge(a.edge_list)
        c.edge_list.merge(b.edge_list)

        print c.score
        return c
     
    cdef void add_edge(self, EisnerNode& a, head, modifier, score):
        a.score += score
        a.edge_list.push_back(pair[int,int](head,modifier))
        return
    """     
    def combine_triangle(self, head, modifier, arc_weight):
        # s < t strictly
        if head == modifier:
            print "invalid head and modifier for combine triangle!!!"
            
        cdef int s, t, q
        if head < modifier:
            s = head
            t = modifier
        else:
            s = modifier
            t = head

        cdef int edge_score = arc_weight(head, modifier)
        
        print "11111self.e[s][s][1][0]   s:", s, "t:",t
        cdef int max_index = s
        print "22222self.e[s][s][1][0]:",self.e[s][s][1][0].score,self.e[s+1][t][0][0].score
        cdef int max_score = \
            self.e[s][s][1][0].score + self.e[s+1][t][0][0].score + edge_score
        print "33333self.e[s][s][1][0]:"
        cdef int cur_score = max_score
        for q from s < q < t by 1:
            print "44444inside for"
            print "s:",s,"q:",q,"t:",t
            cur_score = self.e[s][q][1][0].score + self.e[q+1][t][0][0].score + edge_score
            if max_score < cur_score:
                max_score = cur_score
                max_index = q
        print "55555", max_score, max_index, self.e[s][max_index][1][0].edge_list
        
        cdef list[pair[int, int]] list_a = self.e[s][max_index][1][0].edge_list
        print "66666", list_a
        cdef list[pair[int, int]] list_b = self.e[max_index+1][t][0][0].edge_list
        print "77777", list_b
        list_b.merge(list_a)
        list_b.push_back(pair[int, int](head, modifier))
        
        return max_score, list_b 
    
    cdef EisnerNode combine_left(self, int s, int t):
        print "combine_left"
        # s < t strictly
        
        if s >= t:
            print "invalid head and modifier for combine left!!!"
        
        cdef EisnerNode max_node # = \
        """    self.add_eisner_node(self.e[s][s][0][0], self.e[s][t][0][1])
        
        cdef EisnerNode cur_node
        cdef int q
        for q from s < q < t by 1:
            cur_node = self.add_eisner_node(self.e[s][q][0][0], self.e[q][t][0][1])
            
            if max_node.score < cur_node.score:
                max_node = cur_node
        print max_node.score
        """
        return max_node

    cdef EisnerNode combine_right(self, int s, int t):
        print "combine_right"
        # s < t strictly
        if s >= t:
            print "invalid head and modifier for combine right!!!"
        
        cdef EisnerNode max_node# = \
        """    self.add_eisner_node(self.e[s][s+1][1][1], self.e[s+1][t][1][0])
        
        cdef EisnerNode cur_node
        cdef int q
        for q from s+1 < q <= t by 1:
            cur_node = self.add_eisner_node(self.e[s][q][1][1], self.e[q][t][1][0])
            
            if max_node.score < cur_node.score:
                max_node = cur_node
        print max_node.score
        """
        return max_node    
    
	
    def parse(self, n, arc_weight):	
		# this is the test code for memory allocate n*n*2*2 metrix
		# here I am trying to create a 3*2*2 array and it crashes in my computer
		# if we create a 2*2*2 array, the code works fine
        print n
        cdef P_EisnerNode ***a = <P_EisnerNode***>malloc(n*sizeof(P_EisnerNode**))
        for i in range(n):
            a[i] = <P_EisnerNode**>malloc(2*sizeof(P_EisnerNode*))
            for j in range(2):
                a[i][j] = <P_EisnerNode*>malloc(2*sizeof(P_EisnerNode))
                for k in range(2):
                    a[i][j][k] = <EisnerNode*>malloc(sizeof(EisnerNode))
                    a[i][j][k].score = 0
                    a[i][j][k].edge_list.clear()
        
        print "score", a[0][1][0].score
        print "list", a[0][0][1].edge_list
		
        """
		self.init_eisner_matrix(n)
		
        cdef list[pair[int, int]] a# = [(1,2), (2,3), (3,4)]
        a.push_back((1,2))
        a.push_back((2,2))
        
        cdef list[pair[int, int]] b #= [(2,2), (3,3), (4,4)]
        b.push_back((3,4))
        b.push_back((0,0))
        
        cdef list[pair[int, int]] c = b
        a.merge(c)
        print a
        print b
        print c
        
        cdef int m, s, t, q, q_max
        cdef EisnerNode node  
        #TODO: try for m in range(1,n)

        for m from 1 <= m < n by 1: 
            for s from 0 <= s < n by 1:
                print "s:",s,"m",m
                t = s + m
                if t >= n:
                    break
                print "before max"
                self.e[s][t][0][1].score, self.e[s][t][0][1].edge_list =\
                    self.combine_triangle(t, s, arc_weight)
                
                self.e[s][t][1][1].score, self.e[s][t][1][1].edge_list =\
                    self.combine_triangle(s, t, arc_weight)
                
                self.e[s][t][0][0] = self.combine_left(s, t)
                self.e[s][t][1][0] = self.combine_right(s, t)
                
        return self.eisner_matrix[0][n-1][1][0].edge_list
        """
