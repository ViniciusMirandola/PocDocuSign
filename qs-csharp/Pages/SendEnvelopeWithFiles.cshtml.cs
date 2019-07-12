using DocuSign.eSign.Api;
using DocuSign.eSign.Client;
using DocuSign.eSign.Model;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Text;
using System.Threading.Tasks;

namespace qs_csharp.Pages
{
    public class EnvelopeTemplateFileInfo
    {
        [Required, StringLength(100)]
        public string ModeloId { get; set; }

        [Required, StringLength(100)]
        public string Name { get; set; }

        [Required, StringLength(100)]
        public string Email { get; set; }

        [Required, StringLength(100)]
        public string AssuntoEmail { get; set; }

        [Required]
        public IFormFile UploadAnexo1 { get; set; }

        public IFormFile UploadAnexo2 { get; set; }

        public IFormFile UploadAnexo3 { get; set; }

    }

    public class SendEnvelopeWithFilesModel : PageModel
    {

        [BindProperty]
        public EnvelopeTemplateFileInfo EnvelopeTemplateFileInfo { get; set; }


        // Additional constants
        private const string basePath = "https://demo.docusign.net/restapi";

        public SendEnvelopeWithFilesModel(IOptions<DocusignSettings> config)
        {
            this.config = config;
        }

        private readonly IOptions<DocusignSettings> config;

        public void OnGet()
        {
            ViewData["nomeDestinatario"] = config.Value.UserFullName;
            ViewData["emailDestinatario"] = config.Value.UserEmail;
            ViewData["AssuntoEmail"] = "Entre com o  assunto do e-mail";
            ViewData["TemplateId"] = config.Value.TemplateId;
        }

        public async Task<IActionResult> OnPostAsync()
        {

            if (!ModelState.IsValid)
            {
                ViewData["results"] = $"Informações não preenchidas";

                return new PageResult();
            }


            // Constants need to be set:
            string accessToken = config.Value.AccessToken;
            string accountId = config.Value.AccountId;


            string signerName = EnvelopeTemplateFileInfo.Name;
            string signerEmail = EnvelopeTemplateFileInfo.Email;


            string anexo1 = await ProcessFormFile(EnvelopeTemplateFileInfo.UploadAnexo1);

            string anexo2 = await ProcessFormFile(EnvelopeTemplateFileInfo.UploadAnexo2);

            string anexo3 = await ProcessFormFile(EnvelopeTemplateFileInfo.UploadAnexo3);

            #region [ Anexo 1 ]

            var fileAnexo1 = new FileInfo(anexo1);

            Document document1 = new Document
            {
                AuthoritativeCopy = false,
                Display = "inline",
                DocumentId = "1",
                IncludeInDownload = "true",
                Name = fileAnexo1.Name,
                Order = "1",
                Pages = "1",
                SignerMustAcknowledge = "no_interaction",
                DocumentBase64 = Convert.ToBase64String(ReadContent(anexo1)),
                FileExtension = fileAnexo1.Extension,
                TransformPdfFields = "true"
            };

            List<Document> documents = new List<Document> { document1 };

            #endregion

            #region [ Anexo 2 ]

            if (!string.IsNullOrEmpty(anexo2))
            {
                var fileAnexo2 = new FileInfo(anexo2);

                Document document2 = new Document
                {
                    AuthoritativeCopy = false,
                    Display = "inline",
                    DocumentId = "2",
                    IncludeInDownload = "true",
                    Name = fileAnexo2.Name,
                    Order = "2",
                    Pages = "1",
                    SignerMustAcknowledge = "no_interaction",
                    DocumentBase64 = Convert.ToBase64String(ReadContent(anexo2)),
                    FileExtension = fileAnexo2.Extension,
                    TransformPdfFields = "true"
                };

                documents.Add(document2);
            }

            #endregion

            #region [ Anexo 3 ]

            if (!string.IsNullOrEmpty(anexo3))
            {
                var fileAnexo3 = new FileInfo(anexo3);

                Document document3 = new Document
                {
                    AuthoritativeCopy = false,
                    Display = "inline",
                    DocumentId = "1",
                    IncludeInDownload = "true",
                    Name = fileAnexo3.Name,
                    Order = "3",
                    Pages = "1",
                    SignerMustAcknowledge = "no_interaction",
                    DocumentBase64 = Convert.ToBase64String(ReadContent(anexo3)),
                    FileExtension = fileAnexo3.Extension,
                    TransformPdfFields = "true"
                };

                documents.Add(document3);
            }

            #endregion


            // Step 1. Use the SDK to create and send the envelope
            ApiClient apiClient = new ApiClient(basePath);
            apiClient.Configuration.AddDefaultHeader("Authorization", "Bearer " + accessToken);
            EnvelopesApi envelopesApi = new EnvelopesApi(apiClient.Configuration);

            // Step 2 - Create envelope
            EnvelopeDefinition envelopeDefinition = new EnvelopeDefinition
            {

                EmailSubject = EnvelopeTemplateFileInfo.AssuntoEmail,
                TemplateId = EnvelopeTemplateFileInfo.ModeloId,
                Documents = new List<Document>(documents),
                TemplateRoles = new List<TemplateRole>
                {
                    new TemplateRole
                    {

                        Email = signerEmail,
                        Name = signerName,
                        RoleName = "Customer",
                        RoutingOrder = "1"
                    }
                },
                Status = "sent"
            };

            EnvelopeSummary results = envelopesApi.CreateEnvelope(accountId, envelopeDefinition);

            string envelopeId = results.EnvelopeId;

            var envelope = envelopesApi.GetEnvelope(accountId, envelopeId);

            
            envelope.Recipients = new Recipients
            {
                CertifiedDeliveries = new List<CertifiedDelivery>
                {
                    new CertifiedDelivery
                    {
                        Email = signerEmail,
                        Name = signerName,
                        RoutingOrder = "1"
                    }
                }
            };

            envelope.Status = "sent";


            envelope.PurgeState = null;

            envelopesApi.Update(accountId, envelopeId, envelope );




            ViewData["results"] = $"Envelope status: {results.Status}. Envelope ID: {results.EnvelopeId}";

            return new PageResult();
        }



        /// <summary>
        /// This method read bytes content from the project's Resources directory
        /// </summary>
        /// <param name="fileName">resource path</param>
        /// <returns>return bytes array</returns>
        internal static byte[] ReadContent(string fileName)
        {
            byte[] buff = null;
            string path = Path.Combine(Directory.GetCurrentDirectory(), "Resources", fileName);
            using (FileStream stream = new FileStream(path, FileMode.Open, FileAccess.Read))
            {
                using (BinaryReader br = new BinaryReader(stream))
                {
                    long numBytes = new FileInfo(path).Length;
                    buff = br.ReadBytes((int)numBytes);
                }
            }

            return buff;
        }

        public static async Task<string> ProcessFormFile(IFormFile formFile)
        {
            if (formFile == null || formFile.Length == 0)
            {
                return string.Empty;
            }
            else
            {


                var uploads = Path.Combine(Directory.GetCurrentDirectory(), "Uploads");

                var filePath = Path.Combine(uploads, formFile.FileName);

                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await formFile.CopyToAsync(fileStream);
                }

                return filePath;
            }
        }
    }
}
