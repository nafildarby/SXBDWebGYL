package com.fh.service.Product.Category;

import java.util.List; 

import javax.annotation.Resource; 

import org.springframework.stereotype.Service; 

import com.fh.dao.DaoSupport;   
import com.fh.entity.Page;
import com.fh.entity.Product.Category; 
import com.fh.util.PageData;


@Service("CategoryService")
public class CategoryService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;

	public List<Category> listAllcategory() throws Exception {
		return (List<Category>) dao.findForList("CategoryMapper.listAllcategory", null);
	}

	public List<PageData> listAllPageCate(Page page) throws Exception {
		return (List<PageData>) dao.findForList("CategoryMapper.listAllPageCate",page);
	} 

	public void editCate(PageData pd) throws Exception {
		dao.update("CategoryMapper.editCate", pd); 
		
	}

	public PageData findByCateId(PageData pd) throws Exception {
		return (PageData)dao.findForObject("CategoryMapper.findByCateId", pd);
	} 

	public void deleteCategory(PageData pd) throws Exception {
		dao.delete("CategoryMapper.deleteCategory", pd); 
	}

	public void saveCate(PageData pd) throws Exception {
		dao.save("CategoryMapper.saveCate", pd); 
	}

	public List<PageData> listAllCate() throws Exception {
		return (List<PageData>) dao.findForList("CategoryMapper.listAllCate",null);
	}

	public List<PageData> findByCategoryList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("CategoryMapper.findByCategoryList",pd);
	}
	
	
}
