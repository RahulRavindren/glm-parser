# -*- coding: utf-8 -*-
import feature_set, dependency_tree

HELP_MSG =\
"""
script for merge feature sets

Options:
    -b:     set begin section
    -e:     set end section
    -i:     set iteration
    -p:     set the path db file exists (not used for x,y)
    (the three parameters are used to generate the db file names)

    -x:     set the 1st db file name that would be merged
    -y:     set the 2nd db file name that would be merged
    (x, y would have higher priority than b, e, i)

    -o:     set output db file generated by merge
"""
if __name__ == "__main__":
    import getopt, sys
    db_1 = None
    db_2 = None
    db_name = "train_iter_%s_sec_%d.db"
    db_path = "./penn-wsj-deps/"
    output_file = "merged.db"

    begin_sec = 2
    end_sec = 2
    iteration = '0'
    
    try:
        opt_spec = "hb:e:i:x:y:o:p:"
        opts, args = getopt.getopt(sys.argv[1:], opt_spec)
        for opt, value in opts:
            if opt == "-h":
                print HELP_MSG
                sys.exit(0)
            elif opt == "-b":
                begin_sec = int(value)
            elif opt == "-e":
                end_sec = int(value)
            elif opt == "-i":
                iteration = value
            elif opt == "-x":
                db_1 = value
            elif opt == "-y":
                db_2 = value
            elif opt == "-o":
                output_file = value
            elif opt == "-p":
                db_path = value
            else:
                print "invalid input, see -h"
                sys.exit(0)
    except getopt.GetoptError, e:
        print e 
        print HELP_MSG
        sys.exit(1)

    dt = dependency_tree.DependencyTree()
    
    if db_1 != None and db_2 != None:
        fset_x = feature_set.FeatureSet(dt,operating_mode='memory_dict')
        fset_y = feature_set.FeatureSet(dt,operating_mode='memory_dict')
        fset_x.load(db_1)
        print "fs1 load successfully"
        fset_y.load(db_2)
        print "fs2 load successfully"
        fset_x.merge(fset_y)
        print "merge done"
        fset_x.dump(output_file)
        print "dump done"

    else:
        fset_1 = feature_set.FeatureSet(dt,operating_mode='memory_dict')
        fset_1.load(db_path + db_name%(iteration, end_sec))
        for i in range(begin_sec, end_sec):
            fset_2 = feature_set.FeatureSet(dt,operating_mode='memory_dict')
            fset_2.load(db_path + db_name%(iteration, i))
            print "fs2 " + db_name % (iteration, i) + " load successfully"

            fset_1.merge(fset_2)
            print "merge done"

            del fset_2

        fset_1.dump(output_file)
        print "dump done"
        
        
        
    
