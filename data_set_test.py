# -*- coding: utf-8 -*-
import data_set, weight_learner, glm_parser

def test_weight_learner():
    section_set = [1]
    wl = weight_learner.WeightLearner()
    wl.learn_weight_sections(section_set)
    #wl.learn_weight_sentence('wsj_0099.mrg.3.pa.gs.tab')
    
if __name__ == "__main__":
    
    p = glm_parser.GlmParser()
    p.train([1])
    #test_weight_learner()
    
"""
    ds = data_set.DataSet(section_set=[2])
    i = 0

      
    a = ds.get_data('wsj_0099.mrg.3.pa.gs.tab', 4)
        
    print a.get_word_list()
    print a.get_pos_list()
    print a.get_edge_list()
 """       

