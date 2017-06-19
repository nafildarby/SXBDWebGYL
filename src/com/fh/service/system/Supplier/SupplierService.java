package com.fh.service.system.Supplier;

import java.util.List; 
 
import org.springframework.stereotype.Service; 
  
import com.fh.entity.Page;
import com.fh.service.BaseService; 
import com.fh.util.PageData;


@Service("SupplierService")
public class SupplierService extends BaseService { 
	
	public List<PageData> listAllSupplier() throws Exception {
		return listPageInfo(null,"SupplierMapper.listAllSupplier");
	}

	public List<PageData> supplierlistPage(Page page) throws Exception {
		return listPageInfo(page,"SupplierMapper.supplierlistPage");
	}

	public void saveSupplier(PageData pd) throws Exception {
		dao.save("SupplierMapper.saveSupplier", pd);
	}

	public PageData findSupplierById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("SupplierMapper.findSupplierById", pd);
	}

	public void editSupplier(PageData pd) throws Exception {
		dao.update("SupplierMapper.editSupplier", pd);
	}

	public void deleteSupplier(PageData pd) throws Exception {
		dao.delete("SupplierMapper.deleteSupplier", pd);
	}

	@SuppressWarnings("unchecked")
	public List<PageData> findGoodsBySupplierId(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("SupplierMapper.findGoodsBySupplierId",pd);
	}
	
	@SuppressWarnings("unchecked")
	public List<PageData> findInWHNoBySupplierId(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("SupplierMapper.findInWHNoBySupplierId",pd);
	}
	
}
