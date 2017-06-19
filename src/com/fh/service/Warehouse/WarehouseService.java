package com.fh.service.Warehouse;

import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.fh.dao.DaoSupport;
import com.fh.entity.Page;
import com.fh.entity.Warehouse.Warehouse;
import com.fh.util.PageData;


@Service("WarehouseService")
public class WarehouseService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;

	//查询所有仓库信息
	public List<PageData> listAllWH()throws Exception{
		return (List<PageData>) dao.findForList("WHXMapper.listAllWH",null);
	}
	//查询所有仓库信息
	public List<PageData> listAllPageWH(Page page)throws Exception{
		return (List<PageData>) dao.findForList("WHXMapper.listAllPageWH",page);
	}	
	//修改仓库信息
	public void editWH(PageData pd)throws Exception{
		dao.update("WHXMapper.editWH", pd); 
	}
	//通过Id查询仓库信息
	public PageData findByWHId(PageData pd)throws Exception{
		return (PageData)dao.findForObject("WHXMapper.findByWHId", pd);
	}
	//删除仓库信息
	public void deleteWH(PageData pd)throws Exception{
		dao.delete("WHXMapper.deleteWH", pd); 
	}
	//保存仓库信息
	public void saveWH(PageData pd)throws Exception{
		dao.save("WHXMapper.saveWH", pd); 
	}
	public List<PageData> findByWHList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("WHXMapper.findByWHList",pd);
	}  
	
	
}
