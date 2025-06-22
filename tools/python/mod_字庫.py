import logging
import os
import sys

import xlwings as xw
from dotenv import load_dotenv

from mod_excel_access import ensure_sheet_exists
from mod_logging import logging_exception
from mod_標音 import tlpa_tng_han_ji_piau_im

# =========================================================================
# 載入環境變數
# =========================================================================
load_dotenv()

DB_HO_LOK_UE = os.getenv('DB_HO_LOK_UE', 'Ho_Lok_Ue.db')
DB_KONG_UN = os.getenv('DB_KONG_UN', 'Kong_Un.db')

# =========================================================================
# 設定日誌
# =========================================================================
logging.basicConfig(
    filename='process_log.txt',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def logging_process_step(msg):
    print(msg)
    logging.info(msg)

# =========================================================================
# 常數定義
# =========================================================================
EXIT_CODE_SUCCESS = 0  # 成功
EXIT_CODE_FAILURE = 1
EXIT_CODE_NO_FILE = 1  # 無法找到檔案
EXIT_CODE_INVALID_INPUT = 2  # 輸入錯誤
EXIT_CODE_PROCESS_FAILURE = 3  # 過程失敗
EXIT_CODE_UNKNOWN_ERROR = 99  # 未知錯誤

class JiKhooDict:
    def __init__(self):
        self.ji_khoo_dict = {}

    def items(self):
        for han_ji, entries in self.ji_khoo_dict.items():
            for entry in entries:
                yield (han_ji, entry)

    def add_entry(self, han_ji: str, tai_gi_im_piau: str, kenn_ziann_im_piau: str, coordinates: tuple):
        if not tai_gi_im_piau:
            tai_gi_im_piau = "N/A"
        if not kenn_ziann_im_piau:
            kenn_ziann_im_piau = "N/A"

        entry = {
            "tai_gi_im_piau": tai_gi_im_piau,
            "kenn_ziann_im_piau": kenn_ziann_im_piau,
            "coordinates": [coordinates]
        }

        if han_ji not in self.ji_khoo_dict:
            self.ji_khoo_dict[han_ji] = [entry]
        else:
            for existing in self.ji_khoo_dict[han_ji]:
                if existing["tai_gi_im_piau"] == tai_gi_im_piau:
                    if coordinates not in existing["coordinates"]:
                        existing["coordinates"].append(coordinates)
                    return
            self.ji_khoo_dict[han_ji].append(entry)

    def update_entry(self, han_ji: str, tai_gi_im_piau: str, kenn_ziann_im_piau: str, coordinates: tuple):
        if han_ji not in self.ji_khoo_dict:
            raise ValueError(f"漢字 '{han_ji}' 不存在，請先使用 add_entry 方法新增資料。")

        for existing in self.ji_khoo_dict[han_ji]:
            if existing["tai_gi_im_piau"] == tai_gi_im_piau:
                if kenn_ziann_im_piau:
                    existing["kenn_ziann_im_piau"] = kenn_ziann_im_piau
                if coordinates not in existing["coordinates"]:
                    existing["coordinates"].append(coordinates)
                return

        self.add_entry(han_ji, tai_gi_im_piau, kenn_ziann_im_piau, coordinates)

    def add_or_update_entry(self, han_ji, tai_gi_im_piau, kenn_ziann_im_piau, coordinates):
        self.add_entry(han_ji, tai_gi_im_piau, kenn_ziann_im_piau, coordinates)

    def get_entry(self, han_ji: str):
        if han_ji in self.ji_khoo_dict:
            return self.ji_khoo_dict[han_ji]
        else:
            raise ValueError(f"漢字 '{han_ji}' 不存在於字典中。")

    def get_value_by_key(self, han_ji: str, tai_gi_im_piau: str, key: str):
        if han_ji in self.ji_khoo_dict:
            for entry in self.ji_khoo_dict[han_ji]:
                if entry["tai_gi_im_piau"] == tai_gi_im_piau:
                    return entry.get(key)
            raise ValueError(f"漢字 '{han_ji}' 中找不到音標 '{tai_gi_im_piau}' 對應的欄位 '{key}'。")
        else:
            raise ValueError(f"漢字 '{han_ji}' 不存在於字典中。")


    def update_value_by_key(self, han_ji: str, tai_gi_im_piau: str, key: str, value):
        if han_ji in self.ji_khoo_dict:
            for entry in self.ji_khoo_dict[han_ji]:
                if entry["tai_gi_im_piau"] == tai_gi_im_piau:
                    if key in entry:
                        entry[key] = value
                        return
                    else:
                        raise ValueError(f"欄位名稱 '{key}' 無效。")
            raise ValueError(f"找不到對應音標 '{tai_gi_im_piau}' 的資料。")
        else:
            raise ValueError(f"漢字 '{han_ji}' 不存在於字典中。")

    def update_kau_ziang_im_piau(self, han_ji: str, tai_gi_im_piau: str, kenn_ziann_im_piau: str, coordinates: tuple):
        """
        將人工標音或校正音標更新至字典。
        如果該漢字、音標已存在則更新校正音標與座標。
        若尚未記錄該音標，則新增一筆。
        """
        if han_ji in self.ji_khoo_dict:
            for entry in self.ji_khoo_dict[han_ji]:
                if entry["tai_gi_im_piau"] == tai_gi_im_piau:
                    entry["kenn_ziann_im_piau"] = kenn_ziann_im_piau
                    if coordinates not in entry["coordinates"]:
                        entry["coordinates"].append(coordinates)
                    return
        # 若找不到，則新增新項目
        self.add_entry(han_ji, tai_gi_im_piau, kenn_ziann_im_piau, coordinates)

    def update_by_piau_im_ji_khoo(self, wb, sheet_name: str, piau_im, piau_im_huat: str):
        """
        依【標音字庫】中的【校正音標】欄位進行更新，並將【校正音標】覆蓋至原【台語音標】。
        """
        try:
            han_ji_piau_im_sheet_name = '漢字注音'
            ensure_sheet_exists(wb, han_ji_piau_im_sheet_name)
            han_ji_piau_im_sheet = wb.sheets[han_ji_piau_im_sheet_name]

            piau_im_sheet_name = '標音字庫'
            piau_im_ji_khoo_dict = self.create_ji_khoo_dict_from_sheet(wb, piau_im_sheet_name)
        except Exception as e:
            raise ValueError(f"無法找到或建立工作表 '{sheet_name}'：{e}")

        try:
            for han_ji, entries in piau_im_ji_khoo_dict.ji_khoo_dict.items():
                if not isinstance(entries, list):
                    continue
                for entry in entries:
                    if not isinstance(entry, dict):
                        continue
                    tai_gi_im_piau = entry.get("tai_gi_im_piau", "")
                    kau_ziann_im_piau = entry.get("kenn_ziann_im_piau", "")
                    coordinates = entry.get("coordinates", [])

                    if not kau_ziann_im_piau or kau_ziann_im_piau == 'N/A':
                        if coordinates:
                            row_no, col_no = coordinates[0]
                            msg = f"{han_ji} [{tai_gi_im_piau}] / [{kau_ziann_im_piau}]"
                            print(f"({row_no}, {col_no}) = {msg}")
                        continue

                    for row, col in coordinates:
                        han_ji_piau_im_sheet.activate()
                        han_ji_piau_im_sheet.range((row, col)).select()
                        han_ji_cell = han_ji_piau_im_sheet.range((row, col))
                        tai_gi_im_piau_cell = han_ji_piau_im_sheet.range((row - 1, col))
                        han_ji_piau_im_cell = han_ji_piau_im_sheet.range((row + 1, col))

                        tai_gi_im_piau_cell.value = kau_ziann_im_piau
                        han_ji_piau_im_cell.value = tlpa_tng_han_ji_piau_im(
                            piau_im=piau_im,
                            piau_im_huat=piau_im_huat,
                            tai_gi_im_piau=kau_ziann_im_piau
                        )
                        han_ji_cell.color = (0, 255, 255)
                        han_ji_cell.font.color = (255, 0, 0)

                        msg = f"{han_ji} [{tai_gi_im_piau}] / [{kau_ziann_im_piau}]"
                        print(f"({row}, {col}) = {msg}")

        except Exception as e:
            logging_exception(msg=f"使用【標音字庫】之【校正音標】，改正【漢字注音】之【台語音標】作業異常！", error=e)
            raise

        try:
            piau_im_ji_khoo_dict.write_to_excel_sheet(wb=wb, sheet_name=piau_im_sheet_name)
        except Exception as e:
            logging_exception(msg=f"將【字典】存放之資料，更新工作表作業異常！", error=e)
            raise

        han_ji_piau_im_sheet.range('A1').select()
        return EXIT_CODE_SUCCESS


    def write_to_excel_sheet(self, wb, sheet_name: str) -> int:
        try:
            sheet = wb.sheets[sheet_name]
        except Exception:
            sheet = wb.sheets.add(sheet_name)

        sheet.clear()
        headers = ["漢字", "台語音標", "校正音標", "座標"]
        sheet.range("A1").value = headers

        data = []
        for han_ji, entries in self.ji_khoo_dict.items():
            for entry in entries:
                if not entry["coordinates"]:  # 若座標為空，跳過不寫入
                    continue
                coord_str = "; ".join(f"({r}, {c})" for r, c in entry["coordinates"])
                data.append([han_ji, entry["tai_gi_im_piau"], entry["kenn_ziann_im_piau"], coord_str])

        sheet.range("A2").value = data
        return 0


    def write_to_han_ji_zu_im_sheet(self, wb, sheet_name: str):
        from mod_excel_access import ensure_sheet_exists

        try:
            ensure_sheet_exists(wb, sheet_name)
            sheet = wb.sheets[sheet_name]
        except Exception as e:
            raise ValueError(f"無法找到或建立工作表 '{sheet_name}'：{e}")

        for han_ji, entry in self.items():
            for row, col in entry["coordinates"]:
                sheet.range((row, col)).value = han_ji
                sheet.range((row - 1, col)).value = entry["tai_gi_im_piau"]

        self.write_to_excel_sheet(wb, "缺字表")
        print(f"已成功將字典資料寫入工作表 '{sheet_name}'。")

    def remove_coordinate(self, han_ji: str, tai_gi_im_piau: str, coordinate: tuple):
        """
        移除指定漢字與音標下的某個座標；若座標清空則移除整筆項目。
        """
        if han_ji not in self.ji_khoo_dict:
            return

        entries = self.ji_khoo_dict[han_ji]
        to_delete = None
        for entry in entries:
            if entry["tai_gi_im_piau"] == tai_gi_im_piau:
                if coordinate in entry["coordinates"]:
                    entry["coordinates"].remove(coordinate)
                if len(entry["coordinates"]) == 0:
                    to_delete = entry
                break

        if to_delete:
            entries.remove(to_delete)

    @classmethod
    def create_ji_khoo_dict_from_sheet(cls, wb, sheet_name: str):
        from mod_excel_access import ensure_sheet_exists

        if not ensure_sheet_exists(wb, sheet_name):
            raise ValueError(f"無法找到工作表 '{sheet_name}'。")

        try:
            sheet = wb.sheets[sheet_name]
        except Exception as e:
            raise ValueError(f"無法找到工作表 '{sheet_name}'：{e}")

        data = sheet.range("A2").expand("table").value
        ji_khoo = cls()

        if data is None:
            return ji_khoo
        if not isinstance(data[0], list):
            data = [data]

        for row in data:
            han_ji = row[0] or ""
            tai_gi_im_piau = row[1] or "N/A"
            kenn_ziann_im_piau = row[2] or "N/A"
            coords_str = row[3] or ""

            coordinates = []
            if coords_str:
                coords_list = coords_str.split("; ")
                for coord in coords_list:
                    coord = coord.strip("()")
                    row_col = tuple(map(int, coord.split(", ")))
                    coordinates.append(row_col)

            for coord in coordinates:
                ji_khoo.add_entry(han_ji, tai_gi_im_piau, kenn_ziann_im_piau, coord)

        return ji_khoo

    # def remove_coordinate(self, han_ji: str, tai_gi_im_piau: str, coordinate: tuple):
    #     """
    #     移除指定【漢字】與【台語音標】對應項目中的【座標】。
    #     若該項目座標清單為空，則整筆項目從字典中移除。
    #     """
    #     if han_ji not in self.ji_khoo_dict:
    #         return

    #     entries = self.ji_khoo_dict[han_ji]
    #     for entry in entries:
    #         if entry["tai_gi_im_piau"] == tai_gi_im_piau:
    #             if coordinate in entry["coordinates"]:
    #                 entry["coordinates"].remove(coordinate)
    #             if len(entry["coordinates"]) == 0:
    #                 entries.remove(entry)
    #             break

