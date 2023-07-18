namespace TestGUI
{
    public partial class Form1 : Form
    {
        int count = 0;

        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            
            tbCount.Text = count.ToString();
            count++;
        }
    }
}