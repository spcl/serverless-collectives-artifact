
#include <sstream>
#include <fstream>
#include <vector>

int main()
{
  std::vector<uint64_t> retries_times;
  for(int i = 0; i < 5;++i)
    retries_times.push_back(i);
  std::stringstream ss2;
  ss2 << retries_times.size() << '\n';
  for(int i = 0; i < retries_times.size(); ++i)
    ss2 << retries_times[i] << '\n';

  std::ofstream out("file");
  auto str = ss2.str();
  out.write(str.c_str(), str.length());
  return 0;
}
