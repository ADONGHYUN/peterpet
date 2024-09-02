package kr.co.peterpet.user;

import java.util.List;

public class KaAddr {
	private List<ShippingAddress> shipping_addresses;

	public List<ShippingAddress> getShipping_addresses() {
		return shipping_addresses;
	}

	public void setShipping_addresses(List<ShippingAddress> shipping_addresses) {
		this.shipping_addresses = shipping_addresses;
	}

	public static class ShippingAddress {
		private String base_address;
		private String detail_address;
		private String zone_number;
		public String getBase_address() {
			return base_address;
		}
		public void setBase_address(String base_address) {
			this.base_address = base_address;
		}
		public String getDetail_address() {
			return detail_address;
		}
		public void setDetail_address(String detail_address) {
			this.detail_address = detail_address;
		}
		public String getZone_number() {
			return zone_number;
		}
		public void setZone_number(String zone_number) {
			this.zone_number = zone_number;
		}
		@Override  
		public String toString() {
			return "ShippingAddress [base_address=" + base_address + ", detail_address=" + detail_address
					+ ", zone_number=" + zone_number + "]";
		}
	}
}
